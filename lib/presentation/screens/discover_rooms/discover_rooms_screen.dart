import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/services/discover_room_api_service.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/discover_rooms/hotel_card.dart';
import '../../widgets/discover_rooms/sorting_widget.dart';

class DiscoverRoomsScreen extends StatefulWidget {
  const DiscoverRoomsScreen(
      {super.key,
      this.selectedLocationName,
      this.checkInDate,
      this.checkOutDate});
  final String? selectedLocationName;
  final String? checkInDate;
  final String? checkOutDate;
  @override
  _DiscoverRoomsScreenState createState() => _DiscoverRoomsScreenState();
}

class _DiscoverRoomsScreenState extends State<DiscoverRoomsScreen> {
  int _selectedIndex = 0;
  List<dynamic> _rooms = [];
  List<dynamic> _filteredRooms = [];
  final Map<String, int> _bookings = {};
  Map<String, double> _ratings = {};
  Map<String, int> _availableRooms = {};
  final DiscoverRoomApiService _apiService = DiscoverRoomApiService();
  String? _selectedLocation;
  DateTime? _selectedCheckInDate;
  DateTime? _selectedCheckOutDate;
  final String _searchQuery = '';
  String _sortingOption = 'Nổi bật';
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isSearching = false;
  String _searchResultMessage = '';
  late TextEditingController _textController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args.containsKey('selectedIndex')) {
      _selectedIndex = args['selectedIndex'];
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí không khả dụng');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền truy cập vị trí bị từ chối');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// In _DiscoverRoomsScreenState

  void _filterNearbyHotels() async {
    try {
      setState(() {
        _isLoading = true; // Hiển thị loading indicator
        _filteredRooms = []; // Xóa danh sách cũ trong khi đang tính toán
        _errorMessage = ''; // Xóa thông báo lỗi cũ nếu có
      });

      Position position = await _getCurrentLocation();
      print(
          'Current user position: ${position.latitude}, ${position.longitude}');

      LatLng userLocation = LatLng(position.latitude, position.longitude);
      const Distance distance = Distance();

      print('Total rooms before filtering: ${_rooms.length}');

      List<dynamic> nearbyRooms = [];

      // Tính toán khoảng cách cho từng phòng
      for (var room in _rooms) {
        print('Checking room: ${room['name']}');
        print('Room location data: ${room['location']}');

        if (room['location'] != null &&
            room['location']['latitude'] != null &&
            room['location']['longitude'] != null) {
          double? hotelLat =
              double.tryParse(room['location']['latitude'].toString());
          double? hotelLng =
              double.tryParse(room['location']['longitude'].toString());

          print('Hotel coordinates: $hotelLat, $hotelLng');

          if (hotelLat != null && hotelLng != null) {
            double dist = distance.as(
                LengthUnit.Kilometer, userLocation, LatLng(hotelLat, hotelLng));
            print('Distance to hotel: $dist km');

            if (dist <= 10) {
              // Filter hotels within 10km radius
              nearbyRooms.add(room);
            }
          }
        }
      }

      setState(() {
        _filteredRooms = nearbyRooms;
        _isLoading = false;

        // Thêm thông báo nếu không tìm thấy phòng nào trong bán kính
        if (_filteredRooms.isEmpty) {
          _errorMessage = 'Không tìm thấy phòng nào trong bán kính 10km';
        }
      });

      print('Filtered rooms count: ${_filteredRooms.length}');
    } catch (e) {
      print('Error in _filterNearbyHotels: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể lấy vị trí: $e';
      });
    }
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Fetching rooms...');
      var rooms = await _apiService.fetchRooms();
      print('Fetched ${rooms.length} rooms');

      if (rooms.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No rooms available';
        });
        return;
      }

      // Print first room data for debugging
      if (rooms.isNotEmpty) {
        print('Sample room data: ${rooms[0]}');
      }

      // Ensure location coordinates are properly parsed
      rooms = rooms.map((room) {
        if (room['location'] != null) {
          // Print original location data
          print(
              'Original location data for ${room['name']}: ${room['location']}');

          var latitude = room['location']['latitude']?.toString() ?? '';
          var longitude = room['location']['longitude']?.toString() ?? '';

          room['location'] = {
            ...room['location'],
            'latitude': double.tryParse(latitude) ?? 0.0,
            'longitude': double.tryParse(longitude) ?? 0.0,
          };

          // Print processed location data
          print(
              'Processed location data for ${room['name']}: ${room['location']}');
        }
        return room;
      }).toList();

      DateTime checkInDate = _selectedCheckInDate ?? DateTime.now();
      DateTime checkOutDate =
          _selectedCheckOutDate ?? DateTime.now().add(const Duration(days: 1));

      Map<String, double> ratings = {};
      Map<String, int> availableBuildings = {};

      for (var room in rooms) {
        ratings[room['id']] = _apiService.getAverageRating(room);
        availableBuildings[room['id']] =
            _apiService.getAvailableRooms(room, checkInDate, checkOutDate);
      }

      setState(() {
        _rooms = rooms;
        _filteredRooms = rooms;
        _ratings = ratings;
        _availableRooms = availableBuildings;
        _isLoading = false;
      });

      print('Initial rooms count: ${_rooms.length}');
      print('Initial filtered rooms count: ${_filteredRooms.length}');

      _applyFilters();
    } catch (e) {
      print('Error in _fetchInitialData: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

// Add this method to verify the data structure
  void _verifyDataStructure() {
    print('\n=== Data Structure Verification ===');
    print('Total rooms: ${_rooms.length}');
    print('Filtered rooms: ${_filteredRooms.length}');

    if (_rooms.isNotEmpty) {
      var sampleRoom = _rooms[0];
      print('\nSample Room Data:');
      print('Name: ${sampleRoom['name']}');
      print('Location: ${sampleRoom['location']}');
      print('Rating: ${_ratings[sampleRoom['id']]}');
      print('Available Rooms: ${_availableRooms[sampleRoom['id']]}');
    }

    print('\nCurrent Filters:');
    print('Selected Location: $_selectedLocation');
    print('Sorting Option: $_sortingOption');
    print('=================================\n');
  }

// Call this in initState after _fetchInitialData
  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.selectedLocationName ?? '';
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    _selectedCheckInDate = widget.checkInDate != null
        ? dateFormat.parse(widget.checkInDate!)
        : DateTime.now();
    _selectedCheckOutDate = widget.checkOutDate != null
        ? dateFormat.parse(widget.checkOutDate!)
        : DateTime.now().add(const Duration(days: 1));
    _textController = TextEditingController(text: _selectedLocation);
    _fetchInitialData().then((_) {
      _verifyDataStructure(); // Add this line
    });
  }

  void _applyFilters() async {
    setState(() {
      _isSearching = true; // Bắt đầu tìm kiếm
      _searchResultMessage = ''; // Reset thông báo
    });

    // Tạo một độ trễ nhỏ để hiển thị loading indicator
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      List<dynamic> filtered = _rooms.where((room) {
        final addressLower =
            removeDiacritics(room['address']?.toLowerCase() ?? '');
        final cityLower =
            removeDiacritics(room['location']['city']?.toLowerCase() ?? '');
        final searchLower = _selectedLocation != null
            ? removeDiacritics(_selectedLocation!.toLowerCase())
            : '';

        bool matchesLocation = addressLower.contains(searchLower) ||
            cityLower.contains(searchLower);
        final nameLower = removeDiacritics(room['name']?.toLowerCase() ?? '');
        final searchQueryLower = removeDiacritics(_searchQuery.toLowerCase());
        bool matchesName = nameLower.contains(searchQueryLower);

        return matchesLocation && matchesName;
      }).toList();

      // Áp dụng sắp xếp như cũ
      if (_sortingOption == 'Nổi bật') {
        filtered.sort((a, b) =>
            (_bookings[b['id']] ?? 0).compareTo(_bookings[a['id']] ?? 0));
      } else if (_sortingOption.startsWith('Đánh giá')) {
        String order = _sortingOption.substring('Đánh giá '.length).trim();
        if (order == 'Cao đến thấp') {
          filtered.sort((a, b) =>
              (_ratings[b['id']] ?? 0.0).compareTo(_ratings[a['id']] ?? 0.0));
        } else if (order == 'Thấp đến cao') {
          filtered.sort((a, b) =>
              (_ratings[a['id']] ?? 0.0).compareTo(_ratings[b['id']] ?? 0.0));
        }
      } else if (_sortingOption.startsWith('Giá')) {
        String order = _sortingOption.substring('Giá '.length).trim();
        if (order == 'Cao đến thấp') {
          filtered.sort((a, b) => (b['price']).compareTo(a['price']));
        } else if (order == 'Thấp đến cao') {
          filtered.sort((a, b) => (a['price']).compareTo(b['price']));
        }
      }

      _filteredRooms = filtered;
      _isSearching = false; // Kết thúc tìm kiếm

      // Cập nhật thông báo nếu không tìm thấy kết quả
      if (_filteredRooms.isEmpty && _selectedLocation!.isNotEmpty) {
        _searchResultMessage = 'Không tìm thấy phòng nào ở địa điểm này';
      }
    });
  }

  void _updateSorting(String option) {
    setState(() {
      _sortingOption = option;
    });

    if (option == 'Vị trí của bạn') {
      _filterNearbyHotels();
    } else {
      _applyFilters();
    }
  }

  String removeDiacritics(String str) {
    const vietnamese =
        'ạáảãàâậấẩẫầăặắẳẵằèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ';
    const nonVietnamese =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

    for (int i = 0; i < vietnamese.length; i++) {
      str = str.replaceAll(vietnamese[i], nonVietnamese[i]);
    }
    return str;
  }

  void _pickCheckInDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedCheckInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedCheckInDate = picked;
        if (_selectedCheckOutDate != null &&
            _selectedCheckInDate!.isAfter(_selectedCheckOutDate!)) {
          _selectedCheckOutDate =
              _selectedCheckInDate!.add(const Duration(days: 1));
        }
      });
    }
  }

  void _pickCheckOutDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedCheckOutDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: _selectedCheckInDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedCheckOutDate = picked;
        if (_selectedCheckInDate != null &&
            _selectedCheckOutDate!.isBefore(_selectedCheckInDate!)) {
          _selectedCheckInDate =
              _selectedCheckOutDate!.subtract(const Duration(days: 1));
        }
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'Khám Phá'),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Khám Phá',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'Địa điểm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nhập địa điểm',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
                _applyFilters();
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ngày check-in:'),
                    ElevatedButton(
                      onPressed: _pickCheckInDate,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white, // Màu chữ
                        minimumSize: const Size(150,
                            38), // Kích thước tối thiểu (chiều rộng, chiều cao)
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Bo góc nhỏ hơn
                          side: const BorderSide(
                              color: Colors.black), // Khung màu đen
                        ),
                      ),
                      child: Text(
                        _selectedCheckInDate != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(_selectedCheckInDate!)
                            : 'Chọn ngày check-in',
                        style:
                            const TextStyle(color: Colors.black), // Màu chữ đen
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ngày check-out:'),
                    ElevatedButton(
                      onPressed: _pickCheckOutDate,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white, // Màu chữ
                        minimumSize: const Size(150,
                            38), // Kích thước tối thiểu (chiều rộng, chiều cao)
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Bo góc nhỏ hơn
                          side: const BorderSide(
                              color: Colors.black), // Khung màu đen
                        ),
                      ),
                      child: Text(
                        _selectedCheckOutDate != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(_selectedCheckOutDate!)
                            : 'Chọn ngày check-out',
                        style:
                            const TextStyle(color: Colors.black), // Màu chữ đen
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            SortingWidget(onChanged: (value) {
              _updateSorting(value);
            }),
            const SizedBox(height: 30),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (!_isLoading && _errorMessage.isEmpty)
              ..._filteredRooms.map((room) {
                String locationName = 'N/A';
                if (room.containsKey('location') && room['location'] != null) {
                  locationName = room['location']['city'] ?? 'N/A';
                }
                String address = room['address'] ?? 'No address available';
                return HotelCard(
                  roomId: room['id'],
                  locationId: room['locationId'],
                  imageUrl: room['avatar'],
                  price: '${room['price']}', // Ensure this is a string
                  name: room['name'],
                  location: locationName,
                  address: address,
                  description: room['description'] ?? 'No description',
                  rating: _ratings[room['id']] ?? 0.0, // Default value 0.0
                  bookings: _bookings[room['id']] ?? 0, // Default value 0
                  roomStatus: (_availableRooms[room['id']] ?? 0) > 0
                      ? 'Còn phòng'
                      : 'Hết phòng',
                );
              })
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

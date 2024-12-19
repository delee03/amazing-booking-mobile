import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args.containsKey('selectedIndex')) {
      _selectedIndex = args['selectedIndex'];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

    _fetchInitialData();
  }

  void _applyFilters() {
    setState(() {
      List<dynamic> filtered = _rooms.where((room) {
        final addressLower =
            removeDiacritics(room['address']?.toLowerCase() ?? '');
        final cityLower =
            removeDiacritics(room['location']['city']?.toLowerCase() ?? '');
        final searchLower = _selectedLocation != null
            ? removeDiacritics(_selectedLocation!.toLowerCase())
            : '';

        // Kiểm tra xem địa chỉ hoặc thành phố có chứa từ khóa tìm kiếm không
        bool matchesLocation = addressLower.contains(searchLower) ||
            cityLower.contains(searchLower);

        final nameLower = removeDiacritics(room['name']?.toLowerCase() ?? '');
        final searchQueryLower = removeDiacritics(_searchQuery.toLowerCase());

        bool matchesName = nameLower.contains(searchQueryLower);

        return matchesLocation && matchesName;
      }).toList();

      print(
          'Current sorting option: $_sortingOption'); // Thêm log để kiểm tra _sortingOption

      if (_sortingOption == 'Nổi bật') {
        filtered.sort((a, b) =>
            (_bookings[b['id']] ?? 0).compareTo(_bookings[a['id']] ?? 0));
      } else if (_sortingOption.startsWith('Đánh giá')) {
        String order = _sortingOption.substring('Đánh giá '.length).trim();
        print('Order value: $order'); // Thêm log để kiểm tra giá trị của order

        if (order == 'Cao đến thấp') {
          filtered.sort((a, b) =>
              (_ratings[b['id']] ?? 0.0).compareTo(_ratings[a['id']] ?? 0.0));
        } else if (order == 'Thấp đến cao') {
          filtered.sort((a, b) =>
              (_ratings[a['id']] ?? 0.0).compareTo(_ratings[b['id']] ?? 0.0));
        } else {
          print(
              'Order value did not match expected values'); // Log khi order không khớp với các giá trị mong đợi
        }
      } else if (_sortingOption.startsWith('Giá')) {
        String order = _sortingOption.substring('Giá '.length).trim();
        print('Order value: $order'); // Thêm log để kiểm tra giá trị của order

        if (order == 'Cao đến thấp') {
          filtered.sort((a, b) => (b['price']).compareTo(a['price']));
        } else if (order == 'Thấp đến cao') {
          filtered.sort((a, b) => (a['price']).compareTo(b['price']));
        } else {
          print(
              'Order value did not match expected values'); // Log khi order không khớp với các giá trị mong đợi
        }
      }

      _filteredRooms = filtered;
    });
  }

  void _updateSorting(String option) {
    setState(() {
      _sortingOption = option;
    });
    print(
        'Sorting option updated to: $_sortingOption'); // Thêm log để kiểm tra việc cập nhật _sortingOption
    _applyFilters();
  }

  void _fetchInitialData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var rooms = await _apiService.fetchRooms();
      if (rooms.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No rooms available';
        });
        return;
      }
      DateTime checkInDate = _selectedCheckInDate ?? DateTime.now();
      DateTime checkOutDate =
          _selectedCheckOutDate ?? DateTime.now().add(Duration(days: 1));
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

      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Nhập địa điểm',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                controller: TextEditingController(text: _selectedLocation),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                  _applyFilters(); // Áp dụng bộ lọc khi nhập địa điểm
                },
              ),
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
                        minimumSize: Size(150,
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

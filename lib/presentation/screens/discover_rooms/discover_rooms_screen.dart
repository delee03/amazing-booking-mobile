import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/services/discover_room_api_service.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/discover_rooms/dropdown_widget.dart';
import '../../widgets/discover_rooms/hotel_card.dart';
import '../../widgets/discover_rooms/sorting_widget.dart';

class DiscoverRoomsScreen extends StatefulWidget {
  const DiscoverRoomsScreen(
      {super.key,
      this.selectedLocationId,
      this.checkInDate,
      this.checkOutDate});
  final String? selectedLocationId;
  final String? checkInDate;
  final String? checkOutDate;
  @override
  _DiscoverRoomsScreenState createState() => _DiscoverRoomsScreenState();
}

class _DiscoverRoomsScreenState extends State<DiscoverRoomsScreen> {
  int _selectedIndex = 0;
  List<dynamic> _locations = [];
  List<dynamic> _rooms = [];
  List<dynamic> _filteredRooms = [];
  Map<String, int> _bookings = {};
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
    _selectedLocation = widget.selectedLocationId;
    _selectedCheckInDate = widget.checkInDate != null
        ? DateTime.parse(widget.checkInDate!)
        : DateTime.now();
    _selectedCheckOutDate = widget.checkOutDate != null
        ? DateTime.parse(widget.checkOutDate!)
        : DateTime.now().add(Duration(days: 1));
    // Ngày check-out mặc định là ngày mai
    _fetchInitialData(); // Tải dữ liệu ban đầu
  }

  void _fetchAvailableBuildings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, int> availableBuildings = {};
      DateTime checkInDate = _selectedCheckInDate ?? DateTime.now();
      DateTime checkOutDate =
          _selectedCheckOutDate ?? DateTime.now().add(Duration(days: 1));
      for (var room in _rooms) {
        availableBuildings[room['id']] = await _apiService.getAvailableRooms(
            room['id'], checkInDate, checkOutDate);
      }
      setState(() {
        _availableRooms = availableBuildings;
        _isLoading = false; // Lưu số tòa nhà còn trống
      });
      _applyFilters(); // Áp dụng bộ lọc sau khi kiểm tra trạng thái phòng
    } catch (e) {
      setState(() {
        _errorMessage =
            'Error fetching available buildings: $e'; // Hiển thị thông báo lỗi
      });
    }
  }

  void _applyFilters() {
    setState(() {
      List<dynamic> filtered = _rooms.where((room) {
        final nameLower =
            removeDiacritics(room['name'].toString().toLowerCase());
        final searchLower = removeDiacritics(_searchQuery.toLowerCase());
        bool matchesLocation = _selectedLocation == null ||
            room['locationId'] == _selectedLocation;
        return nameLower.contains(searchLower) && matchesLocation;
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
      var locations = await _apiService.fetchLocations();
      var rooms = await _apiService.fetchRooms();
      var bookings = await _apiService.fetchAllBookings();
      Map<String, int> roomBookings = {};
      for (var booking in bookings) {
        var roomId = booking['roomId'];
        if (roomBookings.containsKey(roomId)) {
          roomBookings[roomId] = roomBookings[roomId]! + 1;
        } else {
          roomBookings[roomId] = 1;
        }
      }
      Map<String, double> ratings = {};
      Map<String, int> availableBuildings = {};
      DateTime checkInDate = _selectedCheckInDate ?? DateTime.now();
      DateTime checkOutDate =
          _selectedCheckOutDate ?? DateTime.now().add(Duration(days: 1));
      for (var room in rooms) {
        ratings[room['id']] = await _apiService.getAverageRating(room['id']);
        availableBuildings[room['id']] = await _apiService.getAvailableRooms(
            room['id'], checkInDate, checkOutDate);
      }
      setState(() {
        _locations = locations;
        _rooms = rooms;
        _filteredRooms = rooms;
        _bookings = roomBookings;
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
          _selectedCheckOutDate = _selectedCheckInDate!.add(Duration(days: 1));
        }
      });
      _fetchAvailableBuildings();
    }
  }

  void _pickCheckOutDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedCheckOutDate ?? DateTime.now().add(Duration(days: 1)),
      firstDate: _selectedCheckInDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedCheckOutDate = picked;
        if (_selectedCheckInDate != null &&
            _selectedCheckOutDate!.isBefore(_selectedCheckInDate!)) {
          _selectedCheckInDate =
              _selectedCheckOutDate!.subtract(Duration(days: 1));
        }
      });
      _fetchAvailableBuildings();
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
            const SizedBox(height: 0),
            LocationDropdown(
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
                _applyFilters(); // Áp dụng bộ lọc khi chọn địa điểm
              },
              locations: _locations, // Truyền danh sách địa điểm
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
                      child: Text(
                        _selectedCheckInDate != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(_selectedCheckInDate!)
                            : 'Chọn ngày check-in',
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
                      child: Text(
                        _selectedCheckOutDate != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(_selectedCheckOutDate!)
                            : 'Chọn ngày check-out',
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
                return HotelCard(
                  imageUrl: room['avatar'],
                  price:
                      '${room['price']}', // Đảm bảo rằng giá trị được truyền là chuỗi
                  name: room['name'],
                  location: _locations.firstWhere(
                          (loc) => loc['id'] == room['locationId'])['city'] ??
                      'N/A',
                  description: room['description'] ?? 'No description',
                  rating:
                      _ratings[room['id']] ?? 0.0, // Giá trị mặc định là 0.0
                  bookings: _bookings[room['id']] ?? 0, // Giá trị mặc định là 0
                  roomStatus: (_availableRooms[room['id']] ?? 0) > 0
                      ? 'Còn phòng'
                      : 'Hết phòng', // Giá trị mặc định dựa trên _availableBuildings
                );
              }).toList(),
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

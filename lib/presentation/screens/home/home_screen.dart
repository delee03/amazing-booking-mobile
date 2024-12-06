import 'dart:math';

import 'package:amazing_booking_app/data/models/hotel.dart';
import 'package:amazing_booking_app/data/services/api_client.dart';
import 'package:amazing_booking_app/presentation/widgets/home/hotel_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/location.dart';
import '../../../data/models/rating.dart';
import '../../widgets/app_drawer.dart';
import '../discover_rooms/discover_rooms_screen.dart';
import '../location_list/location_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTest = 'Option 1';
  String _selectedTes = 'Option 2';
  late Future<List<String>> _locationsFuture;
  late Future<List<Hotel>> futureHotels;
  String? _selectedLocation;
  //Top Location
  List<String> randomImages = [];

  List<String> imageNames = [
    '1.jpg',
    '2.jpg',
    '3.jpg',
    '4.jpg',
    '5.jpg',
    '6.jpg',
    '7.jpg',
    '8.jpg',
    '9.jpg'
  ];

  List<dynamic> locations = [];
  bool isLoading = true;
  List<String> getRandomImages(int count) {
    List<String> shuffledImages = List.from(imageNames);
    shuffledImages.shuffle(Random());

    return shuffledImages.take(count).toList();
  }

  @override
  void initState() {
    super.initState();
    _locationsFuture = _fetchLocations();
    futureHotels = fetchHotels();
    fetchTopLocation();
    randomImages = getRandomImages(6);
  }

  Future<void> fetchTopLocation() async {
    try {
      final apiClient = ApiClient();
      final data = await apiClient.fetchTopLocation();
      setState(() {
        locations = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleLocationTap(String locationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DiscoverRoomsScreen(selectedLocationId: locationId),
      ),
    );
  }

  List<dynamic> getRandomLocations(List<dynamic> locations, int count) {
    final random = Random();
    final List<dynamic> shuffled = List.from(locations)..shuffle(random);
    return shuffled.take(count).toList();
  }

  Future<Map<String, Location>> fetchLocations() async {
    try {
      final response = await ApiClient().get('/locations');

      if (response.statusCode == 200) {
        List<dynamic> content = response.data['content'];
        Map<String, Location> locations = {};
        for (var item in content) {
          Location location = Location.fromJson(item);
          locations[location.id] = location;
        }
        return locations;
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (error) {
      throw Exception('Error fetching locations: $error');
    }
  }

  Future<List<Hotel>> fetchHotels() async {
    try {
      final response = await ApiClient().get('/ratings');

      if (response.statusCode == 200) {
        List<dynamic> content = response.data['content'];

        Map<String, List<int>> ratingMap = {};
        for (var item in content) {
          Rating rating = Rating.fromJson(item);

          if (ratingMap.containsKey(rating.roomId)) {
            ratingMap[rating.roomId]!.add(rating.star);
          } else {
            ratingMap[rating.roomId] = [rating.star];
          }
        }

        // Lấy thông tin địa điểm
        Map<String, Location> locations = await fetchLocations();

        // Sử dụng Set để loại bỏ các phòng trùng lặp
        Set<String> processedRoomIds = {};
        List<Hotel> hotels = [];
        for (var item in content) {
          var room = item['room'];
          if (processedRoomIds.contains(room['id'])) {
            continue; // Bỏ qua nếu phòng đã được xử lý
          }
          processedRoomIds.add(room['id']);
          if (ratingMap[room['id']] == null) {
            continue; // Bỏ qua nếu không có đánh giá nào
          }
          double averageStar = ratingMap[room['id']]!.reduce((a, b) => a + b) /
              ratingMap[room['id']]!.length;

          // Lấy thông tin địa điểm theo id
          String locationName = 'Unknown';
          if (locations.containsKey(room['locationId'])) {
            locationName = locations[room['locationId']]!.city;
          }

          Hotel hotel = Hotel(
            id: room['id'],
            name: room['name'],
            description: room['description'],
            soLuong: room['soLuong'],
            soKhach: room['soKhach'],
            tienNghi: room['tienNghi'],
            price: (room['price'] is int)
                ? (room['price'] as int).toDouble()
                : room['price'],
            avatar: room['avatar'],
            averageStar: averageStar,
            locationName: locationName, // Thêm tên địa điểm vào hotel
          );
          print('Hotel created: $hotel'); // In log từng hotel được tạo
          hotels.add(hotel);
        }

        // Sắp xếp danh sách phòng theo thứ tự trung bình sao từ cao đến thấp
        hotels.sort((a, b) => b.averageStar.compareTo(a.averageStar));
        print('Sorted Hotels: $hotels'); // In log danh sách hotels đã sắp xếp

        // Lấy top 5 phòng
        List<Hotel> topHotels = hotels.take(5).toList();
        return topHotels;
      } else {
        throw Exception('Failed to load ratings');
      }
    } catch (error) {
      throw Exception('Error fetching data');
    }
  }

  Future<List<String>> _fetchLocations() async {
    ApiClient apiClient = ApiClient();
    Response response = await apiClient.get('/locations');
    if (response.statusCode == 200) {
      List<dynamic> content = response.data['content'];
      return content.map((e) => e['city'].toString()).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
            child: SvgPicture.asset(
              'assets/images/logo.svg',
            ),
          ),
        ),
        title: const Text(
          'Amazing Journey',
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppDrawer(), // Menu điều hướng
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white, // Nền trắng cho phần body
          padding: const EdgeInsets.only(
              left: 0, right: 16, top: 16), // Padding xung quanh
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16), // Thụt đầu dòng
                child: Text(
                  'Let\'s Make Your\nBest Trip Ever',
                  style: TextStyle(
                    fontSize: 50, // Kích thước font
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start, // Căn trái
                ),
              ),
              const SizedBox(height: 8), // Khoảng cách giữa các dòng chữ
              const Padding(
                padding: EdgeInsets.only(left: 16.0), // Thụt đầu dòng
                child: Text(
                  'Lên kế hoạch và đặt phòng khách sạn hoàn hảo với lời khuyên của chuyên gia, mẹo du lịch, thông tin điểm đến và nguồn cảm hứng từ chúng tôi.',
                  style: TextStyle(
                    fontSize: 16, // Kích thước font
                    color: Colors.grey, // Màu chữ gray
                  ),
                  textAlign: TextAlign.start, // Căn trái
                ),
              ),
              const SizedBox(
                  height: 20), // Khoảng cách giữa phần văn bản và nút
              // Các nút nằm ngang
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0), // Thụt đầu dòng ngang với 2 dòng chữ phía trên
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Nút Discover Now
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/discover');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444), // Màu nền của nút
                          borderRadius: BorderRadius.circular(12), // Viền tròn
                        ),
                        child: const Text(
                          'Khám phá ngay',
                          style: TextStyle(
                            color: Colors.white, // Màu chữ là trắng
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20), // Khoảng cách giữa các nút

                    // Nút Play (Icon)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white, // Nền trắng cho container ngoài
                        borderRadius: BorderRadius.circular(50), // Viền tròn
                        border: const Border(
                          left: BorderSide(
                            color: Color(
                                0xFFEF4444), // Màu viền đỏ chỉ cho cạnh trái
                            width: 4,
                          ),
                          top: BorderSide.none,
                          right: BorderSide.none,
                          bottom: BorderSide.none,
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Màu nền trắng cho container trong
                          borderRadius:
                              BorderRadius.circular(50), // Viền tròn đều
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.black, // Màu đen cho icon play
                          size: 24,
                        ),
                      ),
                    ),

                    const SizedBox(width: 20), // Khoảng cách giữa các nút

                    // Nút Learn More
                    GestureDetector(
                      onTap: () {
                        // Hành động khi nhấn vào "Learn More"
                      },
                      child: const Text(
                        'Tìm hiểu thêm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Màu chữ đỏ
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Center(
                  child: Image.asset('assets/images/home_page_1.png'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Địa điểm',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<String>>(
                      future: _locationsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final locations = snapshot.data!;
                          if (_selectedLocation == null &&
                              locations.isNotEmpty) {
                            _selectedLocation = locations[0];
                          }
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return DropdownButton<String>(
                                value: _selectedLocation,
                                dropdownColor: Colors.white,
                                elevation: 0,
                                underline: Container(),
                                items: locations.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedLocation = newValue!;
                                  });
                                },
                              );
                            },
                          );
                        } else {
                          return const Text('No locations available');
                        }
                      },
                    ),
                    const SizedBox(height: 1),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Ngày đặt phòng',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedTest = pickedDate.toIso8601String();
                            });
                          }
                        },
                        child: Text(_selectedTest),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Ngày trả phòng',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedTes = pickedDate.toIso8601String();
                            });
                          }
                        },
                        child: Text(_selectedTes),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscoverRoomsScreen(
                                selectedLocationId: _selectedLocation,
                                checkInDate: _selectedTest,
                                checkOutDate: _selectedTes,
                              ),
                            ),
                          );
                        },
                        child: const Text('Tìm kiếm'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiscoverRoomsScreen(
                          selectedLocationId: _selectedLocation,
                          checkInDate: _selectedTest,
                          checkOutDate: _selectedTes,
                        ),
                      ),
                    );
                  },
                  child: FractionallySizedBox(
                    widthFactor: 0.5, // Nút chiếm nửa bên trái của màn hình
                    child: Container(
                      height: 50, // Chiều cao của nút
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444), // Màu nền của nút
                        borderRadius: BorderRadius.circular(12), // Viền tròn
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search, // Biểu tượng tìm kiếm
                            color: Colors.white, // Màu của biểu tượng
                          ),
                          SizedBox(
                              width:
                                  8), // Khoảng cách giữa biểu tượng và văn bản
                          Text(
                            'Tìm kiếm',
                            style: TextStyle(
                              color: Colors.white, // Màu của chữ
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Top Phòng',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8), // Khoảng cách giữa các dòng chữ
              const Padding(
                padding: EdgeInsets.only(left: 16.0), // Thụt đầu dòng
                child: Text(
                  'Đây cũng là những nơi dễ dàng giúp bạn cảm thấy khỏe mạnh hơn, hạnh phúc hơn và ít căng thẳng hơn ở Việt Nam.',
                  style: TextStyle(
                    fontSize: 16, // Kích thước font
                    color: Colors.grey, // Màu chữ gray
                  ),
                  textAlign: TextAlign.start, // Căn trái
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiscoverRoomsScreen(),
                      ),
                    );
                  },
                  child: FractionallySizedBox(
                    widthFactor: 0.5, // Nút chiếm nửa bên trái của màn hình
                    child: Container(
                      height: 50, // Chiều cao của nút
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444), // Màu nền của nút
                        borderRadius: BorderRadius.circular(12), // Viền tròn
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width:
                                  8), // Khoảng cách giữa biểu tượng và văn bản
                          Text(
                            'Xem tất cả',
                            style: TextStyle(
                              color: Colors.white, // Màu của chữ
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              FutureBuilder<List<Hotel>>(
                future: futureHotels,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                            'No rooms available')); // Thông báo khi không có dữ liệu
                  } else {
                    List<Hotel> hotels = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true, // Thêm shrinkWrap
                      physics:
                          NeverScrollableScrollPhysics(), // Ngăn cuộn riêng
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(hotel: hotels[index]);
                      },
                    );
                  }
                },
              ),

              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('Top Địa Điểm',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8), // Khoảng cách giữa các dòng chữ
              const Padding(
                padding: EdgeInsets.only(left: 16.0), // Thụt đầu dòng
                child: Text(
                  'Thật tuyệt vời khi Việt Nam là điểm dừng chân lý tưởng của bạn!',
                  style: TextStyle(
                    fontSize: 16, // Kích thước font
                    color: Colors.grey, // Màu chữ gray
                  ),
                  textAlign: TextAlign.start, // Căn trái
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationListScreen(),
                      ),
                    );
                  },
                  child: FractionallySizedBox(
                    widthFactor: 0.5, // Nút chiếm nửa bên trái của màn hình
                    child: Container(
                      height: 50, // Chiều cao của nút
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444), // Màu nền của nút
                        borderRadius: BorderRadius.circular(12), // Viền tròn
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width:
                                  8), // Khoảng cách giữa biểu tượng và văn bản
                          Text(
                            'Xem tất cả',
                            style: TextStyle(
                              color: Colors.white, // Màu của chữ
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  handleLocationTap(locations[0]['id']);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      // Hiển thị ảnh ngẫu nhiên
                                      Image.asset(
                                        'assets/images/top_location/${randomImages[0]}',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                24,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              locations[0]['country'] ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              locations[0]['city'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  handleLocationTap(locations[1]['id']);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      // Hiển thị ảnh ngẫu nhiên
                                      Image.asset(
                                        'assets/images/top_location/${randomImages[1]}',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                24,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              locations[1]['country'] ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              locations[1]['city'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              handleLocationTap(locations[2]['id']);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  // Hiển thị ảnh ngẫu nhiên
                                  Image.asset(
                                    'assets/images/top_location/${randomImages[2]}',
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            24,
                                    height: 216,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locations[2]['country'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          locations[2]['city'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GestureDetector(
                        onTap: () {
                          handleLocationTap(locations[3]['id']);
                        },
                        child: Stack(
                          children: [
                            // Hiển thị ảnh ngẫu nhiên
                            Image.asset(
                              'assets/images/top_location/${randomImages[3]}',
                              width: MediaQuery.of(context).size.width - 32,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locations[3]['country'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    locations[3]['city'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              handleLocationTap(locations[4]['id']);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  // Hiển thị ảnh ngẫu nhiên
                                  Image.asset(
                                    'assets/images/top_location/${randomImages[4]}',
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            24,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locations[4]['country'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          locations[4]['city'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              handleLocationTap(locations[5]['id']);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  // Hiển thị ảnh ngẫu nhiên
                                  Image.asset(
                                    'assets/images/top_location/${randomImages[5]}',
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            24,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locations[5]['country'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          locations[5]['city'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0), // Thụt trái 16 pixels
                child: Divider(
                  color: Colors.grey, // Màu gạch ngang
                  thickness: 1, // Độ dày gạch ngang
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30, // Chiều rộng mong muốn
                      height: 30, // Chiều cao mong muốn
                      child: FittedBox(
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8.0), // Khoảng cách giữa hình ảnh và văn bản
                    const Text(
                      'Amazing Journey',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0), // Khoảng cách giữa các phần
              const Padding(
                padding:
                    EdgeInsets.only(left: 16.0), // Khoảng cách lệch trái 16
                child: Text(
                  'Trang chủ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0), // Khoảng cách giữa các phần
              const Padding(
                padding:
                    EdgeInsets.only(left: 16.0), // Khoảng cách lệch trái 16
                child: Text(
                  'Về chúng tôi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

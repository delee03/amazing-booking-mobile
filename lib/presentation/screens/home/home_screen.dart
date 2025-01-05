import 'dart:math';

import 'package:amazing_booking_app/data/models/hotel.dart';
import 'package:amazing_booking_app/data/services/api_client.dart';
import 'package:amazing_booking_app/presentation/widgets/home/hotel_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../data/models/location.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/home/location_grid.dart';
import '../discover_rooms/discover_rooms_screen.dart';
import '../location_list/location_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCheckInDate = 'Chọn ngày đặt phòng';
  String _selectedCheckOutDate = 'Chọn ngày trả phòng';
  late Future<List<String>> _locationsFuture;
  late Future<List<Hotel>> futureHotels;
  String? _selectedLocation;
  List<String> randomImages = [];
  List<dynamic> locations = [];
  bool isLoading = true;
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

  ///initState
  @override
  void initState() {
    super.initState();
    _locationsFuture = _fetchLocations();
    futureHotels = fetchHotels();
    fetchTopLocation();
    randomImages = getRandomImages(6);
    _selectedCheckInDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _selectedCheckOutDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().add(const Duration(days: 1)));
  }

  List<String> getRandomImages(int count) {
    if (imageNames.isEmpty) {
      return [];
    }
    List<String> shuffledImages = List.from(imageNames);
    shuffledImages.shuffle(Random());

    return shuffledImages.take(count).toList();
  }

  Future<void> fetchTopLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      final apiClient = ApiClient();
      final data = await apiClient.fetchTopLocation();
      if (data.isEmpty) {
        throw Exception('Không có địa điểm nào');
      }
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
            DiscoverRoomsScreen(selectedLocationName: locationId),
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
      final response = await ApiClient().get('/rooms');

      if (response.statusCode == 200) {
        // Map<String, dynamic> data = response.data;
        // List<dynamic> content = data['content'];
        List<dynamic> content = response.data['content'] ?? [];
        if (content.isEmpty) {
          throw Exception('Không có phòng nào');
        }

        List<Hotel> hotels = [];
        for (var item in content) {
          double averageStar = 0.0;
          if (item['ratings'] != null && item['ratings'].isNotEmpty) {
            List<int> stars = item['ratings']
                .map<int>((rating) => rating['star'] as int)
                .toList();
            averageStar = stars.reduce((a, b) => a + b) / stars.length;
          } else {
            continue; // Bỏ qua nếu không có đánh giá nào
          }

          Hotel hotel = Hotel(
            id: item['id'],
            name: item['name'],
            description: item['description'],
            soLuong: item['soLuong'],
            soKhach: item['soKhach'],
            tienNghi: item['tienNghi'],
            price: (item['price'] is int)
                ? (item['price'] as int).toDouble()
                : item['price'],
            avatar: item['avatar'],
            averageStar: averageStar,
            locationName: item['location']
                ['city'], // Lấy tên thành phố từ location
          );
          hotels.add(hotel);
        }

        // Sắp xếp danh sách phòng theo thứ tự trung bình sao từ cao đến thấp
        hotels.sort((a, b) => b.averageStar.compareTo(a.averageStar));

        // Lấy top 5 phòng
        List<Hotel> topHotels = hotels.take(5).toList();
        return topHotels;
      } else {
        throw Exception('Failed to load rooms');
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

  Widget buildLocationGrid() {
    if (isLoading || locations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return LocationGrid(
      locations: locations,
      images: randomImages,
      onLocationTap: (city) => handleLocationTap(city),
    );
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
                    const SizedBox(height: 0),
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
                              return DropdownButtonFormField<String>(
                                value: _selectedLocation,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white, // Nền trắng
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Bo góc nhỏ hơn
                                    borderSide: const BorderSide(
                                        color: Colors.black), // Khung màu đen
                                  ),
                                  constraints: const BoxConstraints(
                                    minHeight: 38, // Chiều cao tối thiểu
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                elevation: 0,
                                items: locations.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                          color: Colors.black), // Màu chữ đen
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
                      padding: EdgeInsets.only(left: 0.0),
                      child: Text(
                        'Ngày đặt phòng',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
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
                              _selectedCheckInDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(200, 38),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Bo góc nhỏ hơn
                            side: const BorderSide(
                                color: Colors.black), // Khung màu đen
                          ),
                        ),
                        child: Text(
                          _selectedCheckInDate,
                          style: const TextStyle(
                              color: Colors.black), // Màu chữ đen
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child: Text(
                        'Ngày trả phòng',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
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
                              _selectedCheckOutDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          minimumSize: const Size(200, 38),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Bo góc nhỏ hơn
                            side: const BorderSide(
                                color: Colors.black), // Khung màu đen
                          ),
                        ),
                        child: Text(
                          _selectedCheckOutDate,
                          style: const TextStyle(
                              color: Colors.black), // Màu chữ đen
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiscoverRoomsScreen(
                                selectedLocationName:
                                    _selectedLocation, // Truyền địa chỉ đã nhập
                                checkInDate: _selectedCheckInDate,
                                checkOutDate: _selectedCheckOutDate,
                              ),
                            ),
                          );
                        },
                        child: FractionallySizedBox(
                          widthFactor:
                              0.5, // Nút chiếm nửa bên trái của màn hình
                          child: Container(
                            height: 50, // Chiều cao của nút
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444), // Màu nền của nút
                              borderRadius:
                                  BorderRadius.circular(12), // Viền tròn
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
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
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

              buildLocationGrid(),
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

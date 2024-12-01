import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedValue1 = 'Option 1';
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
      drawer: AppDrawer(), // Menu điều hướng
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
                        //Hành động
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
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Địa điểm',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: DropdownButton<String>(
                  value: _selectedValue1,
                  dropdownColor: Colors.white,
                  elevation: 0,
                  underline: Container(),
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValue1 = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Ngày đặt phòng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: DropdownButton<String>(
                  value: _selectedValue1,
                  dropdownColor: Colors.white,
                  elevation: 0,
                  underline: Container(),
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValue1 = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Ngày trả phòng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: DropdownButton<String>(
                  value: _selectedValue1,
                  dropdownColor: Colors.white,
                  elevation: 0,
                  underline: Container(),
                  items: <String>['Option 1', 'Option 2', 'Option 3']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValue1 = newValue!;
                    });
                  },
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Hành động khi nhấn vào nút
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
                child: Text('Top Khách Sạn',
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
                    // Hành động khi nhấn vào nút
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

              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(12), // Bo góc cho toàn bộ nhóm
                    border: const Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Màu viền phía dưới
                        width: 1.0, // Độ dày viền
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12), // Bo góc cho toàn bộ nhóm
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0), // Padding phía dưới
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/img11.jpeg'),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Text(
                              '\$100 /ngày',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Text(
                              'Tên khách sạn',
                              style: TextStyle(
                                color: Color(0xFF1F1D63),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Địa điểm',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Text(
                              'Mô tả chi tiết về khách sạn và các dịch vụ đi kèm.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
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

              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(12), // Bo góc cho toàn bộ nhóm
                    border: const Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Màu viền phía dưới
                        width: 1.0, // Độ dày viền
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12), // Bo góc cho toàn bộ nhóm
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0), // Padding phía dưới
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/img11.jpeg'),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Text(
                              '\$100 /ngày',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Text(
                              'Tên khách sạn',
                              style: TextStyle(
                                color: Color(0xFF1F1D63),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Địa điểm',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.0), // Thụt lề
                            child: Text(
                              'Mô tả chi tiết về khách sạn và các dịch vụ đi kèm.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
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
                    // Hành động khi nhấn vào nút
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
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(8), // Bo góc ảnh
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/img11.jpeg',
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          24,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    const Positioned(
                                      bottom: 8,
                                      left: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Việt Nam',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  16, // Kích cỡ chữ lớn hơn
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Hà Nội', // Tên thành phố
                                            style: TextStyle(
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
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(8), // Bo góc ảnh
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/img11.jpeg',
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          24,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    const Positioned(
                                      bottom: 8,
                                      left: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Việt Nam',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  16, // Kích cỡ chữ lớn hơn
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Hồ Chí Minh', // Tên thành phố
                                            style: TextStyle(
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
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(8), // Bo góc ảnh
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/img11.jpeg',
                                  width: MediaQuery.of(context).size.width / 2 -
                                      24,
                                  height: 216,
                                  fit: BoxFit.cover,
                                ),
                                const Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Việt Nam',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16, // Kích cỡ chữ lớn hơn
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Đà Nẵng', // Tên thành phố
                                        style: TextStyle(
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
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Bo góc ảnh
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/img11.jpeg',
                            width: MediaQuery.of(context).size.width - 32,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const Positioned(
                            bottom: 8,
                            left: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Việt Nam',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16, // Kích cỡ chữ lớn hơn
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Huế', // Tên thành phố
                                  style: TextStyle(
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(8), // Bo góc ảnh
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/img11.jpeg',
                                  width: MediaQuery.of(context).size.width / 2 -
                                      24,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                const Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Việt Nam',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16, // Kích cỡ chữ lớn hơn
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Hải Phòng', // Tên thành phố
                                        style: TextStyle(
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(8), // Bo góc ảnh
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/img11.jpeg',
                                  width: MediaQuery.of(context).size.width / 2 -
                                      24,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                const Positioned(
                                  bottom: 8,
                                  left: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Việt Nam',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16, // Kích cỡ chữ lớn hơn
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Cần Thơ', // Tên thành phố
                                        style: TextStyle(
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
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

int _selectedIndex = 0;
void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

void setState(Null Function() param0) {}

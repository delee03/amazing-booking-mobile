import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 100, // Đặt chiều cao nhỏ hơn của phần tiêu đề "Menu"
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SvgPicture.asset(
                    'assets/images/logo.svg', // Đảm bảo đường dẫn đúng
                    height: 40, // Chỉnh sửa chiều cao logo
                    width: 40, // Chỉnh sửa chiều rộng logo
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      left: 16.0), // Khoảng cách giữa logo và chữ "Menu"
                  child: Text(
                    'Amazing Journey',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Khám phá'),
            onTap: () {
              Navigator.pop(context); // Đóng menu
              // Điều hướng đến màn hình Khám phá
            },
          ),
          ListTile(
            title: const Text('Yêu thích'),
            onTap: () {
              Navigator.pop(context);
              // Điều hướng đến màn hình Yêu thích
            },
          ),
          ListTile(
            title: const Text('Chuyến đi'),
            onTap: () {
              Navigator.pop(context);
              // Điều hướng đến màn hình Chuyến đi
            },
          ),
          ListTile(
            title: const Text('Tin nhắn'),
            onTap: () {
              Navigator.pop(context);
              // Điều hướng đến màn hình Tin nhắn
            },
          ),
          ListTile(
            title: const Text('Hồ sơ'),
            onTap: () {
              Navigator.pop(context);
              // Điều hướng đến màn hình Hồ sơ
            },
          ),
        ],
      ),
    );
  }
}

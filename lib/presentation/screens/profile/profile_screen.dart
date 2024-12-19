import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/user_storage.dart';
import '../../../data/services/auth_service.dart';
import '../../widgets/profile/user_details_dialog.dart';
import '../login/login-page.dart';
import 'booking_history_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoggedIn = false; // Biến kiểm tra trạng thái đăng nhập

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập
  }

  Future<void> _loadUserData() async {
    // Lấy dữ liệu người dùng từ storage
    Map<String, dynamic>? data = await UserStorage.getUserData();
    setState(() {
      userData = data;
    });
  }

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await AuthService().isLoggedIn();
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Hồ sơ", style: TextStyle(color: Color(0xFFEF4444))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEF4444)),
        actions: isLoggedIn
            ? [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
            onPressed: () async {
              await AuthService().logout();
              setState(() {
                isLoggedIn = false;
              });
            },
          ),
        ]
            : null,
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: isLoggedIn
                      ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UserDetailsDialog(
                          userName: userData!['name'] ?? "Chưa có tên",
                          email: userData!['email'] ?? "Chưa có email",
                          phoneNumber: userData!['phone'] ?? "Chưa có số điện thoại",
                          address: userData!['address'] ?? "Chưa có địa chỉ",
                          password: userData!['password'] ?? "Không thể hiển thị mật khẩu",
                          avata: userData!['avata'] ?? "Chưa có avata",
                        );
                      },
                    );
                  }
                      : null,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: userData!['avatar'] != null && userData!['avatar'].isNotEmpty
                        ? NetworkImage(userData!['avatar'])
                        : const AssetImage("assets/images/avata.png") as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading avatar: $exception');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData!['name'] ?? "Chưa có tên",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (isLoggedIn) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfileScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        }
                      },
                      child: Text(isLoggedIn ? "Cập nhật thông tin cá nhân" : "Đăng nhập"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFEF4444)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Lịch sử phòng đã đặt",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (userData != null && userData!.containsKey('id') && isLoggedIn) {
                      List<dynamic> results = await Future.wait([
                        UserStorage.getUserToken(),
                      ]);
                      String token = results[0] as String;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingHistoryScreen(
                            userId: userData!['id'],token: token,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }
                  },
                  child: const Text("Xem chi tiết"),
                ),
                const Divider(color: Color(0xFFEF4444), thickness: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

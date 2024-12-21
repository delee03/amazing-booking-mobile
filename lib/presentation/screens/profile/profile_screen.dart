import 'package:flutter/material.dart';
import '../../../data/models/user_storage.dart';
import '../../../data/services/auth_service.dart';
import '../../widgets/profile/user_details_dialog.dart';
import '../login/login-page.dart';
import 'booking_history_screen.dart';
import 'edit_profile_screen.dart';
import 'comment_history_screen.dart';  // Import màn hình comment

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
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData!['avatar'] != null && userData!['avatar'].isNotEmpty
                        ? NetworkImage(userData!['avatar'])
                        : const AssetImage("assets/images/avata.png") as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading avatar: $exception');
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userData!['name'] ?? "Chưa có tên",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            _buildInfoBox(
              title: "Lịch sử đặt phòng",
              subtitle: "Lịch sử đặt phòng gần đây",
              icon: Icons.history,
              onTap: () async {
                if (userData != null && userData!.containsKey('id') && isLoggedIn) {
                  List<dynamic> results = await Future.wait([
                    UserStorage.getUserToken(),
                  ]);
                  String token = results[0] as String;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingHistoryScreen(
                        userId: userData!['id'],
                        token: token,
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
            ),
            const SizedBox(height: 10),
            _buildInfoBox(
              title: "Bình luận",
              subtitle: "Các bình luận gần đây",
              icon: Icons.comment,
              onTap: () async {
                if (userData != null && userData!.containsKey('id') && isLoggedIn) {
                  String? token = await UserStorage.getUserToken();
                  if (token != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentHistoryScreen(
                          userId: userData!['id'],
                          token: token,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox({required String title, required String subtitle, required IconData icon, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        height: 100, // Đặt chiều cao cố định
        child: Row(
          children: [
            Icon(icon, color: Color(0xFFEF4444)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFEF4444)),
          ],
        ),
      ),
    );
  }
}

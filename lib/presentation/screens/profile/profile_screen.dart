import 'package:flutter/material.dart';
import '../../../data/models/user_storage.dart';
import 'booking_history_screen.dart'; // Import BookingHistoryScreen
import 'edit_profile_screen.dart'; // Import EditProfileScreen


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? data = await UserStorage.getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Hồ sơ", style: TextStyle(color: Color(0xFFEF4444))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFEF4444)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFFEF4444)),
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator if data is not loaded
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UserDetailsDialog(
                            userName: userData!['name'] ?? "Chưa có tên",
                            email: userData!['email'] ?? "Chưa có email",
                            phoneNumber: userData!['phone'] ?? "Chưa có số điện thoại",
                            address: userData!['address'] ?? "Chưa có địa chỉ",
                            password: userData!['password'] ?? "Không thể hiển thị mật khẩu",
                            avata: userData!['avata'] ?? "Chưa có avata" ,
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: userData!['avatar'] != null && userData!['avatar'].isNotEmpty
                          ? NetworkImage(userData!['avatar'])
                          : AssetImage("assets/images/avata.png") as ImageProvider,
                      onBackgroundImageError: (exception, stackTrace) {
                        print('Error loading avatar: $exception');
                      },
                    )

                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData!['name'] ?? "Chưa có tên",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );
                      },
                      child: Text("Cập nhật thông tin cá nhân"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Color(0xFFEF4444)),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    backgroundColor: Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (userData != null && userData!.containsKey('id')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingHistoryScreen(
                            userId: userData!['id'],  // Truyền userId vào
                          ),
                        ),
                      );
                    }
                  },
                  child: Text("Xem chi tiết"),
                ),
                Divider(color: Color(0xFFEF4444), thickness: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// UserDetailsDialog class
class UserDetailsDialog extends StatelessWidget {
  final String avata;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  const UserDetailsDialog({
    Key? key,
    required this.avata,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Thông tin người dùng", style: TextStyle(color: Color(0xFFEF4444))),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            SizedBox(height: 16),
            Text("Tên người dùng: $userName", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Email: $email", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Số điện thoại: $phoneNumber", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Địa chỉ: $address", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Mật khẩu: ********", style: TextStyle(fontSize: 18)), // Mask password for security
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Đóng", style: TextStyle(color: Color(0xFFEF4444))),
        ),
      ],
    );
  }
}

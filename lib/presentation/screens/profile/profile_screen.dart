import 'package:flutter/material.dart';
import 'booking_detail_screen.dart';
import 'booking_history_screen.dart'; // Import BookingHistoryScreen
import 'edit_profile_screen.dart'; // Import EditProfileScreen

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Hồ sơ",
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
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
      body: Column(
        children: [
          // Profile Header with Image on the left and Name on the right
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40, // Adjust size as needed
                  backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                ),
                SizedBox(width: 16), // Space between image and name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tên người dùng", // User name
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEF4444), // Red background
                        foregroundColor: Colors.white, // White text
                      ),
                      onPressed: () {
                        // Navigate to EditProfileScreen to update the profile
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
          // List of booking items
          ListView.builder(
            shrinkWrap: true, // Remove extra space at the bottom
            itemCount: 3, // Giới hạn 3
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookingDetailScreen()),
                  );
                },
                child: BookingItem(
                  roomName: "Phòng $index",
                  bookingDate: "01/12/2024",
                  expiryDate: "01/01/2025",
                  imageUrl: "https://via.placeholder.com/150",
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF4444), // Nền nút đỏ
                    foregroundColor: Colors.white, // Chữ trắng
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingHistoryScreen()),
                    );
                  },
                  child: Text("Xem thêm"),
                ),
                Divider(color: Color(0xFFEF4444), thickness: 1), // Divider at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingItem extends StatelessWidget {
  final String roomName;
  final String bookingDate;
  final String expiryDate;
  final String imageUrl;

  const BookingItem({
    Key? key,
    required this.roomName,
    required this.bookingDate,
    required this.expiryDate,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ListTile(
          leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(roomName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ngày đặt: $bookingDate", style: TextStyle(color: Colors.black)),
              Text("Ngày hết hạn: $expiryDate", style: TextStyle(color: Colors.black)),
            ],
          ),
          trailing: Icon(Icons.arrow_forward, color: Color(0xFFEF4444)),
        ),
      ),
    );
  }
}

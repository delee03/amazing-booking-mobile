import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chỉnh sửa hồ sơ",
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50, // Adjust size as needed
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Tên người dùng",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444), // Red background
                foregroundColor: Colors.white, // White text
              ),
              onPressed: () {
                // Save profile changes logic
                Navigator.pop(context); // Go back to ProfileScreen after saving
              },
              child: Text("Lưu thay đổi"),
            ),
          ],
        ),
      ),
    );
  }
}

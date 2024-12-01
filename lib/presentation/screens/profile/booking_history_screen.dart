import 'package:flutter/material.dart';
import 'booking_detail_screen.dart'; // Import BookingDetailScreen

class BookingHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch sử đặt phòng",
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: ListView.builder(
        itemCount: 10, // Example: 10 rooms for demonstration
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to BookingDetailScreen when a room is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingDetailScreen()),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text("Phòng $index"),
                subtitle: Text("Ngày đặt: 01/12/2024\nNgày hết hạn: 01/01/2025"),
              ),
            ),
          );
        },
      ),
    );
  }
}

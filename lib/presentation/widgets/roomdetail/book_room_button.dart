import 'package:flutter/material.dart';
import '../../screens/booking/booking_screen.dart';

class BookRoomButton extends StatelessWidget {
  final int totalPrice;

  BookRoomButton({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Đảm bảo nút có chiều dài bằng màn hình
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFEF4444), // Màu nút #EF4444
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(
                roomName: "Studio nhìn ra tháp Eiffel",
                roomImage:
                "https://images.unsplash.com/photo-1560448204-e00d7cac1445",
                checkIn: DateTime(2024, 11, 30),
                checkOut: DateTime(2024, 12, 3),
                totalPrice: totalPrice,
              ),
            ),
          );
        },
        child: Text(
          "Đặt phòng",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BookingItem extends StatelessWidget {
  final String roomName;
  final String bookingDate;
  final Color textColor;
  final VoidCallback onTap;

  BookingItem({required this.roomName, required this.bookingDate, required this.textColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(roomName, style: TextStyle(color: textColor)),
      subtitle: Text("Ngày đặt: $bookingDate", style: TextStyle(color: textColor)),
      trailing: Icon(Icons.arrow_forward, color: textColor),
      onTap: onTap,
    );
  }
}

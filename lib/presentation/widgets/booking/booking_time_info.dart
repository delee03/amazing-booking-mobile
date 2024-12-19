import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingTimeInfo extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;

  const BookingTimeInfo({super.key, required this.checkIn, required this.checkOut});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thời gian đặt phòng",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Ngày nhận phòng: ${formatter.format(checkIn)}"),
          Text("Ngày trả phòng: ${formatter.format(checkOut)}"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BookingPriceDetails extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final int pricePerDay;
  final int maxGues;

  // Constructor nhận thêm checkIn, checkOut, và giá phòng mỗi ngày
  BookingPriceDetails({
    required this.checkIn,
    required this.checkOut,
    required this.pricePerDay,
    required int totalPrice,
    required this.maxGues
  });

  @override
  Widget build(BuildContext context) {
    // Tính số ngày đặt phòng
    int numberOfDays = checkOut.difference(checkIn).inDays;
    if (numberOfDays <= 0) {
      numberOfDays = 1; // Nếu ngày nhận và trả trùng nhau, đặt mặc định là 1 ngày
    }

    // Tính tổng giá
    int totalPrice = numberOfDays * pricePerDay;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chi tiết",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Số khách: $maxGues"),
          const SizedBox(height: 8),
          Text("Số ngày đặt phòng: $numberOfDays ngày"),
          const SizedBox(height: 8),
          Text("Giá mỗi ngày: ${pricePerDay.toStringAsFixed(2)} \VND"),
          const SizedBox(height: 8),
          Text(
            "Tổng cộng: ${totalPrice.toStringAsFixed(2)} \VND",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

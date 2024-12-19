
import 'package:amazing_booking_app/data/models/booking/booking.dart';
import 'package:amazing_booking_app/presentation/screens/profile/room_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../roomdetail/room_detail_screen.dart'; // Import the RoomDetailScreen

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đặt phòng"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Phòng: ${booking.room.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Ngày nhận phòng: ${DateFormat('dd/MM/yyyy').format(booking.checkIn.toLocal())}"),
            Text("Ngày trả phòng: ${DateFormat('dd/MM/yyyy').format(booking.checkOut.toLocal())}"),
            Text("Tổng giá: ${booking.totalPrice}"),
            Text("Phương thức thanh toán: ${booking.paymentMethod}"),
            Text("Trạng thái thanh toán: ${booking.paymentStatus ? 'Đã thanh toán' : 'Chưa thanh toán'}"),
            // Thêm các thông tin chi tiết khác nếu cần
          ],
        ),
      ),
    );
  }
}


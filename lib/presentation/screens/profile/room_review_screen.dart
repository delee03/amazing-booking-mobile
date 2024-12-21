import 'package:amazing_booking_app/data/models/booking/booking.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../data/services/api_client.dart'; // Import Dio

class RoomReviewScreen extends StatefulWidget {
  final Booking booking;
  final String token;

  RoomReviewScreen({super.key, required this.booking, required this.token});

  @override
  _RoomReviewScreenState createState() => _RoomReviewScreenState();
}

class _RoomReviewScreenState extends State<RoomReviewScreen> {
  int selectedStar = 0; // Số sao được chọn
  final TextEditingController _reviewController = TextEditingController();

  void _submitReview() async {
    final review = {
      "content": _reviewController.text,
      "star": selectedStar,
      "userId": widget.booking.user?.id,
      "roomId": widget.booking.room.id
    };

    try {
      final response = await ApiClient().dio.post(
        '/ratings',
        data: review,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${widget.token}',
          },
        ),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đánh giá của bạn đã được gửi!")),
        );
        Navigator.pop(context, true); // Trả về kết quả thành công
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gửi đánh giá thất bại, vui lòng thử lại!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Đánh giá phòng",
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nội dung đánh giá",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                hintText: "Viết đánh giá của bạn...",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              cursorColor: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            const Text(
              "Đánh giá",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      selectedStar = index + 1; // Cập nhật số sao được chọn
                    });
                  },
                  icon: Icon(
                    index < selectedStar
                        ? Icons.star // Sao đã chọn sẽ có màu đỏ
                        : Icons.star_border_outlined, // Sao chưa chọn có viền rỗng
                    color: Color(0xFFEF4444), // Màu viền sao
                    size: 32,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4444), // Nền nút đỏ
                  foregroundColor: Colors.white, // Chữ trắng
                ),
                onPressed: _submitReview,
                child: const Text("Gửi đánh giá"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

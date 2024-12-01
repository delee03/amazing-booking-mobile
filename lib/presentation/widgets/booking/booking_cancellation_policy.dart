import 'package:flutter/material.dart';

class BookingCancellationPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chính sách hủy phòng",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Bạn có thể hủy phòng miễn phí trước 24 giờ. Sau 24 giờ, sẽ áp dụng phí hủy là 50% giá trị đơn đặt phòng.",
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

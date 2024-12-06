import 'package:flutter/material.dart';

class RoomPriceNotice extends StatelessWidget {
  final int pricePerDay; // Tham số nhận giá phòng mỗi ngày từ API
  final int totalPrice; // Tham số nhận tổng giá tiền đã tính từ API

  RoomPriceNotice({
    required this.pricePerDay,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.pink, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_offer, color: Colors.pink, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                // Thông báo giá phòng với giá trị cụ thể
                "Giá thấp hơn: Những ngày bạn chọn có giá thấp hơn ${totalPrice} VND so với mức giá trung bình theo đêm trong 60 ngày qua.",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

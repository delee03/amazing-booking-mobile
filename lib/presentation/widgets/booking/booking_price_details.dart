import 'package:flutter/material.dart';

class BookingPriceDetails extends StatelessWidget {
  final int totalPrice;

  BookingPriceDetails({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chi tiết giá",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("3 đêm x \$200: \$600"),
          SizedBox(height: 8),
          Text(
            "Tổng cộng: \$${totalPrice}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

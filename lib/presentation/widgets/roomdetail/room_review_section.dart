import 'package:flutter/material.dart';

class RoomReviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.orange, size: 16),
          SizedBox(width: 4),
          Text(
            "4.86",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(
            "· 577 đánh giá",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

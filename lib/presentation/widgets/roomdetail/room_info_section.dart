import 'package:flutter/material.dart';

class RoomInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Studio nhìn ra tháp Eiffel tuyệt đẹp & Ban công riêng",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                "Phòng tại Paris, Pháp",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "1 giường queen · Phòng tắm khép kín",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RoomAmenitiesSection extends StatelessWidget {
  final List<String> amenities = [
    "Wi-Fi miễn phí",
    "Máy lạnh",
    "TV màn hình phẳng",
    "Bếp đầy đủ tiện nghi",
    "Máy giặt",
    "Ban công riêng",
    "Bồn tắm",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tiện ích phòng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Sử dụng ListView để hiển thị tiện ích
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: amenities.map((amenity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      amenity,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

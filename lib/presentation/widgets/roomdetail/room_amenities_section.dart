import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomAmenitiesSection extends StatelessWidget {
  final List<String> amenities; // Chỉnh sửa để nhận List<String> thay vì String

  RoomAmenitiesSection({required this.amenities});

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
          const SizedBox(height: 16),
          // Hiển thị danh sách tiện ích
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: amenities.map((amenity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        amenity.trim(), // Loại bỏ khoảng trắng thừa
                        style: const TextStyle(fontSize: 16),
                      ),
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

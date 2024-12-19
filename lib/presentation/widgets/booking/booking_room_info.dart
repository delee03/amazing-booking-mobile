import 'package:flutter/material.dart';

import '../roomdetail/room_image_slider.dart';

class BookingRoomInfo extends StatelessWidget {
  final String roomName;
  final Future<List<String>> imagesFuture;

  // Constructor nhận thông tin phòng từ màn hình khác
  const BookingRoomInfo({super.key,
    required this.roomName,
    required this.imagesFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị slider hình ảnh
        RoomImageSlider(imagesFuture: imagesFuture),
        const SizedBox(height: 16), // Khoảng cách giữa slider và tên phòng
        // Tên phòng nằm dưới slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Thêm padding ngang
          child: Text(
            roomName,
            style: const TextStyle(
              fontSize: 20, // Tăng kích thước chữ
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 2, // Giới hạn 2 dòng
            overflow: TextOverflow.ellipsis, // Cắt chữ nếu quá dài
          ),
        ),
      ],
    );
  }
}

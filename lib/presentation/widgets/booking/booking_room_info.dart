import 'package:flutter/material.dart';

class BookingRoomInfo extends StatelessWidget {
  final String roomName;
  final String roomImage;

  // Thêm Constructor để nhận thông tin phòng từ màn hình khác
  BookingRoomInfo({required this.roomName, required this.roomImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trên nếu Text nhiều dòng
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              roomImage,
              width: 50, // Đảm bảo không vượt quá
              height: 50,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image, // Hiển thị icon nếu hình ảnh không tải được
                  size: 50,
                );
              },
            ),
          ),
          SizedBox(width: 16),
          // Đảm bảo Text không tràn
          Expanded(
            child: Text(
              roomName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2, // Giới hạn 2 dòng
              overflow: TextOverflow.ellipsis, // Cắt nếu vượt quá
            ),
          ),
        ],
      ),
    );
  }
}

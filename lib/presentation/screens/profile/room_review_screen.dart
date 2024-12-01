import 'package:flutter/material.dart';

class RoomReviewScreen extends StatefulWidget {
  @override
  _RoomReviewScreenState createState() => _RoomReviewScreenState();
}

class _RoomReviewScreenState extends State<RoomReviewScreen> {
  int selectedStar = 0; // Số sao được chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Đánh giá phòng",
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Tên", labelStyle: TextStyle(color: Colors.black)),
              cursorColor: Color(0xFFEF4444),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Nội dung đánh giá",
                labelStyle: TextStyle(color: Colors.black),
              ),
              maxLines: 4,
              cursorColor: Color(0xFFEF4444),
            ),
            SizedBox(height: 16),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444), // Nền nút đỏ
                foregroundColor: Colors.white, // Chữ trắng
              ),
              onPressed: () {
                // Xử lý lưu đánh giá
              },
              child: Text("Gửi đánh giá"),
            ),
          ],
        ),
      ),
    );
  }
}

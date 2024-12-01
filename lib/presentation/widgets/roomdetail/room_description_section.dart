import 'package:flutter/material.dart';

class RoomDescriptionSection extends StatefulWidget {
  @override
  _RoomDescriptionSectionState createState() => _RoomDescriptionSectionState();
}

class _RoomDescriptionSectionState extends State<RoomDescriptionSection> {
  bool _isExpanded = false; // Biến để theo dõi trạng thái mở rộng

  final String description =
      "Căn phòng này có không gian rộng rãi, với tầm nhìn trực tiếp ra tháp Eiffel. "
      "Phòng được trang bị đầy đủ tiện nghi, bao gồm một giường queen thoải mái, "
      "TV màn hình phẳng, máy lạnh và bếp đầy đủ dụng cụ nấu ăn. "
      "Ban công riêng mang lại không gian thư giãn tuyệt vời, đặc biệt là vào buổi tối khi bạn có thể ngắm nhìn cảnh đẹp thành phố. "
      "Một lựa chọn lý tưởng cho những ai muốn trải nghiệm Paris trong một không gian tiện nghi và sang trọng.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mô tả căn phòng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Toggle trạng thái mở rộng
              });
            },
            child: Text(
              _isExpanded
                  ? description
                  : (description.length > 150
                  ? description.substring(0, 150) + '...' // Hiển thị dấu "..."
                  : description),
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
          SizedBox(height: 8),
          if (!_isExpanded)
            Text(
              "Xem thêm",
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
        ],
      ),
    );
  }
}

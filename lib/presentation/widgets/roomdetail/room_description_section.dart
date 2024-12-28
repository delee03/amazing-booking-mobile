import 'package:flutter/material.dart';

class RoomDescriptionSection extends StatefulWidget {
  final String description; // Mô tả phòng
  final int soKhach; // Số khách tối đa

  const RoomDescriptionSection({
    super.key,
    required this.description,
    required this.soKhach, // Nhận thêm số khách tối đa từ API
  });

  @override
  _RoomDescriptionSectionState createState() => _RoomDescriptionSectionState();
}

class _RoomDescriptionSectionState extends State<RoomDescriptionSection> {
  bool _isExpanded = false; // Trạng thái mở rộng hoặc thu gọn

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mô tả",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Hiển thị số khách tối đa
          const SizedBox(height: 8),
          // Hiển thị mô tả phòng với trạng thái mở rộng/thu gọn
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // Toggle trạng thái mở rộng
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isExpanded
                      ? widget.description // Hiển thị toàn bộ mô tả
                      : (widget.description.length > 150
                      ? '${widget.description.substring(0, 150)}...' // Rút gọn và hiển thị dấu "..."
                      : widget.description),
                  style: const TextStyle(fontSize: 14, height: 1.6),
                ),
                if (widget.description.length > 150) // Chỉ hiển thị nút nếu mô tả dài hơn 150 ký tự
                  Text(
                    _isExpanded ? 'Thu gọn' : 'Xem thêm',
                    style: const TextStyle(color: Colors.blue, fontSize: 14),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          Text(
            "Số khách tối đa: ${widget.soKhach} người",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

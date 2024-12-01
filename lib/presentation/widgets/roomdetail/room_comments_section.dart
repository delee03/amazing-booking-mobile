import 'package:flutter/material.dart';

class RoomCommentsSection extends StatelessWidget {
  final List<Map<String, dynamic>> comments = [
    {
      "name": "Nguyễn Văn A",
      "comment": "Phòng rất đẹp, view tháp Eiffel tuyệt vời! Phòng rất sạch sẽ và đầy đủ tiện nghi, tôi rất hài lòng với dịch vụ tại đây.",
      "rating": 5,
      "date": "25/11/2024"
    },
    {
      "name": "Trần Thị B",
      "comment": "Chủ nhà thân thiện và nhiệt tình. Sẽ quay lại lần nữa! Mọi thứ đều tuyệt vời.Phòng rất đẹp, view tháp Eiffel tuyệt vời! Phòng rất sạch sẽ và đầy đủ tiện nghi, tôi rất hài lòng với dịch vụ tại đây.",
      "rating": 4,
      "date": "20/11/2024"
    },
    {
      "name": "Lê Văn C",
      "comment": "Phòng sạch sẽ, đầy đủ tiện nghi. Tuy nhiên giá hơi cao.Phòng rất đẹp, view tháp Eiffel tuyệt vời! Phòng rất sạch sẽ và đầy đủ tiện nghi, tôi rất hài lòng với dịch vụ tại đây.",
      "rating": 3,
      "date": "15/11/2024"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bình luận đánh giá",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Sử dụng SingleChildScrollView với trục ngang (horizontal scroll)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: comments.map((comment) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    width: 300, // Kích thước cho mỗi phần bình luận
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.grey, size: 20),
                            SizedBox(width: 8),
                            Text(
                              comment['name']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              comment['date']!,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            comment['rating']!,
                                (index) => Icon(Icons.star, color: Colors.orange, size: 16),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Hiển thị comment ngắn gọn với dấu "..."
                        GestureDetector(
                          onTap: () {
                            _showFullComment(context, comment['comment']!);
                          },
                          child: Text(
                            comment['comment']!,
                            style: TextStyle(fontSize: 14),
                            maxLines: 3, // Giới hạn hiển thị 3 dòng
                            overflow: TextOverflow.ellipsis, // Hiển thị dấu "..."
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị đầy đủ bình luận khi người dùng nhấn vào
  void _showFullComment(BuildContext context, String fullComment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chi tiết bình luận"),
          content: Text(fullComment),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }
}

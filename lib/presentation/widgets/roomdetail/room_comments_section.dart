import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl

import '../../../data/models/Comment.dart';

class RoomCommentsSection extends StatelessWidget {
  late final Future<List<Comment>> commentsFuture;

  RoomCommentsSection({required this.commentsFuture});

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
          FutureBuilder<List<Comment>>(
            future: commentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Không thể tải bình luận: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Chưa có bình luận nào.");
              } else {
                // Sắp xếp bình luận theo thời gian (gần nhất trước)
                final comments = snapshot.data!..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Cuộn ngang
                  child: Row(
                    children: comments.map((comment) {
                      // Định dạng ngày theo định dạng "dd/MM/yyyy"
                      String formattedDate = DateFormat('dd/MM/yyyy').format(comment.createdAt);

                      return GestureDetector(
                        onTap: () {
                          // Mở hộp thoại hiển thị chi tiết bình luận
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Chi tiết bình luận"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(comment.user.avatar),
                                        radius: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        comment.user.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    comment.content,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Ngày: $formattedDate",
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Đóng"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            width: 250, // Chiều rộng cố định
                            height: 150, // Chiều cao cố định
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(comment.user.avatar),
                                      radius: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.user.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: List.generate(
                                    comment.star,
                                        (index) =>
                                        Icon(Icons.star, color: Colors.orange, size: 16),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  comment.content,
                                  maxLines: 2, // Giới hạn hiển thị 2 dòng
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

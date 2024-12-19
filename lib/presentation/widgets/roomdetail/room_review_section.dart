import 'package:flutter/material.dart';
import '../../../data/models/Comment.dart';

class RoomReviewSection extends StatelessWidget {
  final Future<List<Comment>> commentsFuture; // Danh sách bình luận

  const RoomReviewSection({super.key, required this.commentsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comment>>(
      future: commentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi khi tải đánh giá: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Chưa có đánh giá nào.'));
        }

        // Lấy danh sách bình luận
        final comments = snapshot.data!;

        // Tính tổng số sao và số lượng đánh giá
        final double averageRating =
            comments.map((comment) => comment.star).reduce((a, b) => a + b) /
                comments.length;
        final int reviewCount = comments.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 20),
              const SizedBox(width: 4),
              Text(
                averageRating.toStringAsFixed(1), // Hiển thị trung bình sao
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                "· $reviewCount đánh giá", // Hiển thị số lượng đánh giá
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}

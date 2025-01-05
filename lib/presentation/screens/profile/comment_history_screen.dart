import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../data/services/api_client.dart';

class CommentHistoryScreen extends StatefulWidget {
  final String userId;
  final String token;

  const CommentHistoryScreen(
      {required this.userId, required this.token, super.key});

  @override
  _CommentHistoryScreenState createState() => _CommentHistoryScreenState();
}

class _CommentHistoryScreenState extends State<CommentHistoryScreen> {
  List<dynamic> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    ApiClient apiClient = ApiClient();
    apiClient.setAuthorizationToken(widget.token);

    try {
      Response response = await apiClient.get("/ratings/user/${widget.userId}");
      setState(() {
        comments = response.data["content"];
      });
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  Future<void> deleteComment(String commentId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa bình luận này không?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      ApiClient apiClient = ApiClient();
      apiClient.setAuthorizationToken(widget.token);

      try {
        await apiClient.delete("/ratings/$commentId");
        setState(() {
          comments.removeWhere((comment) => comment['id'] == commentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bình luận đã được xóa thành công')),
        );
      } catch (e) {
        print("Error deleting comment: $e");
      }
    }
  }

  Future<void> editComment(String commentId, String content, int star) async {
    ApiClient apiClient = ApiClient();
    apiClient.setAuthorizationToken(widget.token);

    try {
      await apiClient.patch("/ratings/$commentId", data: {
        'content': content,
        'star': star,
        'userId': widget.userId,
        'roomId': comments
            .firstWhere((comment) => comment['id'] == commentId)['roomId'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bình luận đã được chỉnh sửa thành công')),
      );
      fetchComments(); // Reload comments
    } catch (e) {
      print("Error editing comment: $e");
    }
  }

  void showEditDialog(
      String commentId, String initialContent, int initialStar) {
    final contentController = TextEditingController(text: initialContent);
    int selectedStar = initialStar;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh sửa bình luận'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nội dung đánh giá",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: "Viết đánh giá của bạn...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    cursorColor: Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Đánh giá",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedStar =
                                index + 1; // Cập nhật số sao được chọn
                          });
                        },
                        icon: Icon(
                          index < selectedStar
                              ? Icons.star // Sao đã chọn sẽ có màu đỏ
                              : Icons
                                  .star_border_outlined, // Sao chưa chọn có viền rỗng
                          color: Color(0xFFEF4444), // Màu viền sao
                          size: 32,
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                editComment(
                  commentId,
                  contentController.text,
                  selectedStar,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bình luận của bạn",
            style: TextStyle(color: Color(0xFFEF4444))),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: comments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final room = comment['room'];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      room['avatar'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    ),
                    title: Text(room['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment['content']),
                        const SizedBox(height: 5),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < comment['star']
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Color(0xFFEF4444),
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showEditDialog(comment['id'], comment['content'],
                                comment['star']);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteComment(comment['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

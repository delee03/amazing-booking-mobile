class Rating {
  final String id;
  final String content;
  final int star;
  final String userId;
  final String roomId;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.content,
    required this.star,
    required this.userId,
    required this.roomId,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    print('Creating Rating from JSON: $json'); // In log dữ liệu JSON
    return Rating(
      id: json['id'],
      content: json['content'],
      star: json['star'],
      userId: json['userId'],
      roomId: json['roomId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

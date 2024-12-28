class Rating {
  final String id;
  final String content;
  final int star;
  final String userId;
  final String roomId;

  Rating({
    required this.id,
    required this.content,
    required this.star,
    required this.userId,
    required this.roomId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      content: json['content'],
      star: json['star'],
      userId: json['userId'],
      roomId: json['roomId'],
    );
  }
}

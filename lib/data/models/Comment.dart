import 'Room.dart';
import 'User.dart';

class Comment {
  final String id;
  final String content;
  final int star;
  final String userId;
  final String roomId;
  final DateTime createdAt;
  final User user; // Thông tin user
  final Room room; // Thông tin room

  Comment({
    required this.id,
    required this.content,
    required this.star,
    required this.userId,
    required this.roomId,
    required this.createdAt,
    required this.user,
    required this.room,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      star: json['star'] ?? 0,
      userId: json['userId'] ?? '',
      roomId: json['roomId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      user: User.fromJson(json['user']),
      room: Room.fromJson(json['room']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'star': star,
      'userId': userId,
      'roomId': roomId,
      'createdAt': createdAt.toIso8601String(),
      'user': user.toJson(),
      'room': room.toJson(),
    };
  }
}

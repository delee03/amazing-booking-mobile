import 'package:amazing_booking_app/data/models/Room.dart';

class RoomImage {
  final String id;
  final String url;
  final String roomId;
  final Room room;

  RoomImage({
    required this.id,
    required this.url,
    required this.roomId,
    required this.room,
  });

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json['id'],
      url: json['url'],
      roomId: json['roomId'],
      room: Room.fromJson(json['room']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'roomId': roomId,
      'room': room.toJson(),
    };
  }
}

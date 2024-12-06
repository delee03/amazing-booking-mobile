import 'Room.dart';
import 'User.dart';

class Booking {
  final String id;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;
  final int guests;
  final String userId;
  final String roomId;
  final String paymentMethod;
  final bool paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Room room;
  final User user;

  Booking({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.guests,
    required this.userId,
    required this.roomId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.room,
    required this.user,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      totalPrice: json['totalPrice'],
      guests: json['guests'],
      userId: json['userId'],
      roomId: json['roomId'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      room: Room.fromJson(json['room']),
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'totalPrice': totalPrice,
      'guests': guests,
      'userId': userId,
      'roomId': roomId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'room': room.toJson(),
      'user': user.toJson(),
    };
  }
}
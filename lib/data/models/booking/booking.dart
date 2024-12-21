import 'package:amazing_booking_app/data/models/booking/room.dart';
import 'package:amazing_booking_app/data/models/booking/user.dart';

class Booking {
  final String id;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;
  final String paymentMethod;
  final bool paymentStatus;
  final Room room;
  final User? user; // Có thể null nếu API không trả về thông tin User
  final int guests; // Thêm trường guests
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.room,
    this.user,
    required this.guests, // Thêm vào constructor
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      totalPrice: json['totalPrice'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      room: Room.fromJson(json['room']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      guests: json['guests'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

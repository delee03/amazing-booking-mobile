import 'package:amazing_booking_app/data/models/location.dart';

class Room {
  final String id;
  final String name;
  final String description;
  final int soLuong;
  final int soKhach;
  final String tienNghi;
  final int price;
  final String avatar;
  final String locationId;
  final String address;
  final bool status;
  final String type;
  final String longitude;
  final String latitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Location location;
  final List<dynamic> bookings;
  final List<dynamic> images;
  final List<dynamic> ratings;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.soLuong,
    required this.soKhach,
    required this.tienNghi,
    required this.price,
    required this.avatar,
    required this.locationId,
    required this.address,
    required this.status,
    required this.type,
    required this.longitude,
    required this.latitude,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
    required this.bookings,
    required this.images,
    required this.ratings,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      soKhach: json['soKhach'] ?? 0,
      tienNghi: json['tienNghi'] ?? '',
      price: json['price'] ?? 0,
      avatar: json['avatar'] ?? '',
      locationId: json['locationId'] ?? '',
      address: json['address'] ?? '',
      status: json['status'] ?? false,
      type: json['type'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
      location: Location.fromJson(json['location'] ?? {}),
      bookings: json['bookings'] ?? [],
      images: json['images'] ?? [],
      ratings: json['ratings'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'soLuong': soLuong,
      'soKhach': soKhach,
      'tienNghi': tienNghi,
      'price': price,
      'avatar': avatar,
      'locationId': locationId,
      'address': address,
      'status': status,
      'type': type,
      'longitude': longitude,
      'latitude': latitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'location': location.toJson(),
      'bookings': bookings,
      'images': images,
      'ratings': ratings,
    };
  }
}

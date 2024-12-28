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
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      totalPrice: json['totalPrice'] ?? 0,
      guests: json['guests'] ?? 0,
      userId: json['userId'] ?? '',
      roomId: json['roomId'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'totalPrice': totalPrice,
      'guests': guests,
      'userId': userId,
      'roomId': roomId,
      'paymentMethod': paymentMethod,
      'paymentStatus': false,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}

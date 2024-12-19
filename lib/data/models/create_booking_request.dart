class CreateBookingRequest {
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;
  final String userId;
  final String roomId;
  final int guests;
  final String paymentMethod;
  final bool paymentStatus;

  CreateBookingRequest({
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.userId,
    required this.roomId,
    required this.guests,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'totalPrice': totalPrice,
      'userId': userId,
      'roomId': roomId,
      'guests': guests,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }
}
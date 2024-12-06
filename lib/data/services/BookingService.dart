import 'package:flutter/cupertino.dart';

import '../models/Booking.dart';
import '../models/user_storage.dart';
import 'api_client.dart';

class BookingService {
  final ApiClient _apiClient = ApiClient();

  Future<Booking> createBooking({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required String paymentMethod,
    required int totalPrice, // Thêm totalPrice vào
    required bool paymentStatus, // Thêm paymentStatus vào
  }) async {
    try {
      // Lấy userId từ UserStorage
      Map<String, dynamic>? userData = await UserStorage.getUserData();
      if (userData == null || !userData.containsKey('id')) {
        throw Exception('Không tìm thấy thông tin người dùng.');
      }
      String userId = userData['id'];

      // Gửi yêu cầu tạo đơn đặt phòng
      final response = await _apiClient.post('/booking', data: {
        'roomId': roomId,
        'userId': userId, // Thêm userId vào payload
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'totalPrice': totalPrice, // Thêm trường totalPrice
        'guests': guests, // Thêm trường guests
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus, // Thêm trường paymentStatut
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Booking.fromJson(response.data);
      } else {
        throw Exception("Failed to create booking: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error creating booking: $e");
      throw Exception("Error creating booking: $e");
    }
  }


  // Lấy tất cả các đơn đặt phòng
  Future<List<Booking>> fetchAllBookings() async {
    try {
      final response = await _apiClient.get('/booking');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((item) => Booking.fromJson(item)).toList();
      } else {
        throw Exception("Failed to fetch bookings: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching bookings: $e");
    }
  }

  // Lấy chi tiết đơn đặt phòng theo ID
  Future<Booking> fetchBookingById(String bookingId) async {
    try {
      final response = await _apiClient.get('/booking/$bookingId');
      if (response.statusCode == 200) {
        return Booking.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch booking: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching booking: $e");
    }
  }

  // Cập nhật thông tin đơn đặt phòng
  Future<Booking> updateBooking({
    required String bookingId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final response = await _apiClient.put('/booking/$bookingId', data: updatedData);
      if (response.statusCode == 200) {
        return Booking.fromJson(response.data);
      } else {
        throw Exception("Failed to update booking: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating booking: $e");
    }
  }

  // Lấy tất cả đơn đặt phòng theo userId
  Future<List<Booking>> fetchBookingsByUserId(String userId) async {
    try {
      final response = await _apiClient.get('/booking/user/$userId');
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Booking.fromJson(e)).toList();
      } else {
        throw Exception("Failed to fetch bookings: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching bookings: $e");
    }
  }

  // Lấy URL thanh toán VNPay
  Future<String> fetchVNPayUrl(String bookingId) async {
    try {
      final response = await _apiClient.get('/booking/vnpay-url/$bookingId');
      if (response.statusCode == 200) {
        return response.data as String;
      } else {
        throw Exception("Failed to fetch VNPay URL: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching VNPay URL: $e");
    }
  }
}

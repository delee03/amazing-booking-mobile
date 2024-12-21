import 'package:dio/dio.dart';

import 'api_client.dart';
import '../models/booking.dart';
import '../models/user_storage.dart';
import 'package:flutter/cupertino.dart';

class BookingService {
  final ApiClient apiClient = ApiClient();

  T _handleResponse<T>(Response response, T Function(dynamic data) parser) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return parser(response.data);
    }
    throw Exception('API Error: ${response.statusCode}');
  }

  Future<String> _getAuthToken() async {
    final token = await UserStorage.getUserToken();
    if (token == null) throw Exception('Authentication token not found');
    return token;
  }

  Future<String> _getUserId() async {
    final userData = await UserStorage.getUserData();
    if (userData == null || !userData.containsKey('id')) {
      throw Exception('User data not found');
    }
    return userData['id'];
  }

  Future<DateTime> _formatDateTime(DateTime date) async {
    return DateTime.utc(date.year, date.month, date.day, 0, 0, 0, 0);
  }

  Future<Booking?> createBooking({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int guests,
    required String paymentMethod,
    required int totalPrice,
    required bool paymentStatus,
    required BuildContext context,
  }) async {
    try {
      final userId = await _getUserId();
      final token = await _getAuthToken();
      final data = {
        'roomId': roomId,
        'userId': userId,
        'checkIn': (await _formatDateTime(checkIn)).toIso8601String(),
        'checkOut': (await _formatDateTime(checkOut)).toIso8601String(),
        'totalPrice': totalPrice,
        'guests': guests,
        'paymentMethod': paymentMethod,
        'paymentStatus': false,
      };

      final response = await apiClient.post(
        '/booking',
        data: data,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('API response data: ${response.data}'); // In ra dữ liệu trả về từ API

      final bookingData = response.data['content'];
      if (bookingData == null) {
        throw Exception('Booking content is null');
      }

      return _handleResponse(response, (data) => Booking.fromJson(bookingData));
    } catch (e) {
      print('Booking creation failed: $e');
      return null;
    }
  }


  Future<List<Booking>> fetchAllBookings() async {
    try {
      final response = await apiClient.get('/booking');
      return _handleResponse(response,
              (data) => (data as List).map((item) => Booking.fromJson(item)).toList());
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }

  Future<Booking> fetchBookingById(String bookingId) async {
    try {
      final response = await apiClient.get('/booking/$bookingId');
      return _handleResponse(response, (data) => Booking.fromJson(data));
    } catch (e) {
      throw Exception('Error fetching booking: $e');
    }
  }

  Future<Booking> updateBooking({
    required String bookingId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final response = await apiClient.put(
        '/booking/$bookingId',
        data: updatedData,
      );
      return _handleResponse(response, (data) => Booking.fromJson(data));
    } catch (e) {
      throw Exception('Error updating booking: $e');
    }
  }

  Future<List<Booking>> fetchBookingsByUserId(String userId) async {
    try {
      final response = await apiClient.get('/booking/user/$userId');
      return _handleResponse(response,
              (data) => (data as List).map((e) => Booking.fromJson(e)).toList());
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  Future<String> fetchVNPayUrl(String bookingId) async {
    try {
      final response = await apiClient.get('/booking/vnpay-url/$bookingId');
      return _handleResponse(response, (data) => data as String);
    } catch (e) {
      throw Exception('Error fetching VNPay URL: $e');
    }
  }
}

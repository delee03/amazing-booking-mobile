import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';

import '../models/Booking.dart';

import '../models/user_storage.dart';

class BookingService {
  static const String _baseUrl = 'http://13.229.251.144';

  final Dio _dio;

  BookingService() : _dio = Dio(BaseOptions(baseUrl: _baseUrl));

// Helper method to handle API responses

  T _handleResponse<T>(Response response, T Function(dynamic data) parser) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return parser(response.data);
    }

    throw Exception('API Error: ${response.statusCode}');
  }

// Helper method to get auth token

  Future<String> _getAuthToken() async {
    final token = await UserStorage.getUserToken();

    if (token == null) throw Exception('Authentication token not found');

    return token;
  }

// Helper method to get user data

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

      final response = await _dio.post(
        '/booking',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
// Kiểm tra và lấy data từ response

        final responseData = response.data['content'] ?? response.data;

        return Booking.fromJson(responseData);
      }

      return _handleResponse(response, (data) => Booking.fromJson(data));
    } on Exception catch (e) {
      print('Booking creation failed: $e');

      return null;
    }
  }

  Future<List<Booking>> fetchAllBookings() async {
    try {
      final response = await _dio.get('/booking');

      return _handleResponse(
          response,
          (data) =>
              (data as List).map((item) => Booking.fromJson(item)).toList());
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }

  Future<Booking> fetchBookingById(String bookingId) async {
    try {
      final response = await _dio.get('/booking/$bookingId');

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
      final response = await _dio.put('/booking/$bookingId', data: updatedData);

      return _handleResponse(response, (data) => Booking.fromJson(data));
    } catch (e) {
      throw Exception('Error updating booking: $e');
    }
  }

  Future<List<Booking>> fetchBookingsByUserId(String userId) async {
    try {
      final response = await _dio.get('/booking/user/$userId');

      return _handleResponse(response,
          (data) => (data as List).map((e) => Booking.fromJson(e)).toList());
    } catch (e) {
      throw Exception('Error fetching user bookings: $e');
    }
  }

  Future<String> fetchVNPayUrl(String bookingId) async {
    try {
      final response = await _dio.get('/booking/vnpay-url/$bookingId');

      return _handleResponse(response, (data) => data as String);
    } catch (e) {
      throw Exception('Error fetching VNPay URL: $e');
    }
  }
}

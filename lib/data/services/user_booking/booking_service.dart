import 'package:amazing_booking_app/data/models/booking/booking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingService {
  final String baseUrl = 'http://13.229.251.144';

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print("Error decoding JSON: $e, Response Body: ${response.body}");
        throw Exception('Lỗi xử lý dữ liệu từ server.');
      }
    } else {
      print('API Error: ${response.statusCode}, Body: ${response.body}');
      switch (response.statusCode) {
        case 400:
          throw Exception('Yêu cầu không hợp lệ (Bad Request).');
        case 401:
          throw Exception('Chưa được xác thực (Unauthorized).');
        case 403:
          throw Exception('Bị cấm (Forbidden).');
        case 404:
          throw Exception('Không tìm thấy tài nguyên (Not Found).');
        case 500:
          throw Exception('Lỗi server (Internal Server Error).');
        default:
          throw Exception('Lỗi không xác định: ${response.statusCode}.');
      }
    }
  }

  Future<List<Booking>> fetchBookingsByUserId(
      String userId, String token) async {
    final url = Uri.parse('$baseUrl/booking/user/$userId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      final jsonData = _handleResponse(response);

      if (jsonData is Map && jsonData.containsKey('content')) {
        final List<dynamic> bookingJson = jsonData['content'];
        return bookingJson.map((json) => Booking.fromJson(json)).toList();
      } else {
        print("jsonData không đúng định dạng: $jsonData");
        throw Exception("Dữ liệu trả về từ server không đúng định dạng.");
      }
    } catch (e) {
      print('Lỗi khi lấy bookings: $e');
      rethrow;
    }
  }

  Future<Booking?> fetchBookingById(String bookingId, String token) async {
    final url = Uri.parse('$baseUrl/booking/$bookingId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      final jsonData = _handleResponse(response);
      if (jsonData != null && jsonData['content'] != null) {
        return Booking.fromJson(jsonData['content']);
      } else {
        print('Invalid response format for fetchBookingById: $jsonData');
        return null;
      }
    } catch (e) {
      print('Error fetching booking by ID: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(String bookingId, String token) async {
    final url = Uri.parse('$baseUrl/booking/$bookingId');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.delete(url, headers: headers);
      _handleResponse(response);
    } catch (e) {
      print('Lỗi khi xóa booking: $e');
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';

import '../../models/booking/booking.dart';
import '../api_client.dart';


class BookingService {
  final ApiClient apiClient = ApiClient();

  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }

  Future<List<Booking>> fetchBookingsByUserId(String userId, String token) async {
    final response = await apiClient.get(
      '/booking/user/$userId',
      headers: {'Authorization': 'Bearer $token'},
    );
    final jsonData = _handleResponse(response);
    return (jsonData['content'] as List).map((json) => Booking.fromJson(json)).toList();
  }

  Future<Booking?> fetchBookingById(String bookingId, String token) async {
    final response = await apiClient.get(
      '/booking/$bookingId',
      headers: {'Authorization': 'Bearer $token'},
    );
    final jsonData = _handleResponse(response);
    return jsonData['content'] != null ? Booking.fromJson(jsonData['content']) : null;
  }

  Future<void> deleteBooking(String bookingId, String token) async {
    final response = await apiClient.delete(
      '/booking/$bookingId',
      headers: {'Authorization': 'Bearer $token'},
    );
    _handleResponse(response);
  }
}

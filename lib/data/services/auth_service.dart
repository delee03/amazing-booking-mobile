import 'package:amazing_booking_app/data/services/api_client.dart';
import 'package:dio/dio.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> login(String email, String password) async {
    try {
      final response = await _apiClient.post("/auth/signin", data: {
        "email": email,
        "password": password,
      });

      // Lưu thông tin đăng nhập vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data['token']);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.post("/auth/signup", data: {
        "name": name,
        "email": email,
        "password": password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Phương pháp kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // Phương pháp đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

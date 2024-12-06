import 'package:amazing_booking_app/data/services/api_client.dart';
import 'package:dio/dio.dart';


class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> login(String email, String password) async {
    try {
      print("Initiating login API call...");
      final response = await _apiClient.post("/auth/signin", data: {
        "email": email,
        "password": password,
      });
      print("Login API call successful!");
      print("Response Data: ${response.data}");
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
}

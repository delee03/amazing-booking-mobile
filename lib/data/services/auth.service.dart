import 'package:amazing_booking_app/core/utils/saving_sesion.dart';
import 'package:amazing_booking_app/data/services/api-client.dart';
import 'package:dio/dio.dart';


class AuthService {
  final ApiClient _apiClient = ApiClient();
  final SessionManager _sessionManager = SessionManager();

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

  Future<Response> register(String name, String email, String password,
      String phone, String birthday, bool gender) async {
    print("Initiating register API call...");
    try {
      final response = await _apiClient.post("/auth/register", data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "birthday": birthday,
        "gender": gender,
      });
      print("Register API call successful!");
      print("Response Data: ${response.data}");
      return response;
    } catch (e) {
      print("Register API call failed with error: $e");
      rethrow;
    }
  }
}
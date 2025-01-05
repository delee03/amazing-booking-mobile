import 'dart:convert';

import 'package:amazing_booking_app/data/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Đăng nhập
  Future<Response> login(String email, String password) async {
    try {
      final response = await _apiClient.post("/auth/signin", data: {
        "email": email,
        "password": password,
      });

      // Lưu token vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data['token']);
      return response;
    } catch (e) {
      // In trường hợp có lỗi, ném lại lỗi
      rethrow;
    }
  }

  /// Định dạng ngày sinh UTC
  Future<DateTime> _formatDateTime(DateTime date) async {
    return DateTime.utc(date.year, date.month, date.day, 0, 0, 0, 0);
  }

  /// Đăng ký người dùng
  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
    required DateTime birthday,
    required bool gender,
    String role = "USER", // Mặc định là USER
  }) async {
    try {
      final formattedBirthday =
          await _formatDateTime(birthday); // Định dạng ngày sinh UTC

      final response = await _apiClient.post("/auth/signup", data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "avatar": avatar,
        "birthday": formattedBirthday.toIso8601String(),
        "gender": gender,
        "role": role,
      });

      return response;
    } catch (e) {
      rethrow; // Ném lại lỗi nếu có
    }
  }

  /// Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  /// Đăng xuất
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  ///Đăng nhập với Google
  Future<void> googleSignIn() async {
    try {
      // Bắt đầu đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        Fluttertoast.showToast(msg: "Đăng nhập Google bị hủy.");
        return;
      }

      // Lấy token từ Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception("Không thể lấy idToken từ Google.");
      }

      // Gửi token đến API của bạn qua ApiClient
      final response = await _apiClient.post('/auth/google', data: {
        'token': idToken,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['content']['user'];

        if (token != null && user != null) {
          // Lưu token và thông tin người dùng vào SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('user', jsonEncode(user));

          Fluttertoast.showToast(msg: "Đăng nhập Google thành công!");
        } else {
          Fluttertoast.showToast(
              msg: "Đăng nhập thất bại: Dữ liệu không hợp lệ.");
        }
      } else {
        final errorMessage = response.data['message'] ?? "Lỗi không xác định.";
        print("Đăng nhập thất bại: $errorMessage");
      }
    } catch (e) {
      print("Đăng nhập Google thất bại: $e");
    }
  }
}

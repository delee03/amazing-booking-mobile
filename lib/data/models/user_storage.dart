import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  // Lưu trữ thông tin người dùng
  static Future<void> saveUserData(Map<String, dynamic> userData, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(userData));
    await prefs.setString('userToken', token);
  }
  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    return token != null && token.isNotEmpty;
  }


  // Lấy thông tin người dùng
  static Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    if (userData != null) {
      return Map<String, dynamic>.from(jsonDecode(userData));
    }
    return null;
  }

  // Lấy token
  static Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // Xóa thông tin người dùng khi đăng xuất
  static Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    await prefs.remove('userToken');
  }
}

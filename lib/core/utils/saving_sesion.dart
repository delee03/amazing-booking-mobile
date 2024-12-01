import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyAuthToken = 'auth_token';

  // Save the authentication token
  Future<void> saveAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAuthToken, token);
  }

  // Retrieve the authentication token
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAuthToken);
  }

  // Clear the authentication token
  Future<void> clearAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAuthToken);
  }
}
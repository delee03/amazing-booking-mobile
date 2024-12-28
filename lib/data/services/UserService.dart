import 'api_client.dart';  // Đảm bảo bạn có ApiClient
import '../models/User.dart';  // Đảm bảo bạn có lớp User

class UserService {
  final ApiClient _apiClient = ApiClient();

  // Phương thức lấy thông tin người dùng
  Future<User> fetchUser(String userId) async {
    try {
      final response = await _apiClient.get('/users/$userId');
      if (response.statusCode == 200) {
        final dynamic content = response.data['content'];
        if (content != null) {
          return User.fromJson(content); // Trả về đối tượng User
        } else {
          throw Exception("User details are null");
        }
      } else {
        throw Exception("Failed to fetch user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching user: $e");
    }
  }

  // Phương thức cập nhật thông tin người dùng
  Future<User> updateUser(
      String userId, {
        required String name,
        required String email,
        required String birthday,
        required bool gender,
        required String phone,
        required String password,
        required String avatar,
        required String role,
      }) async {
    try {
      final response = await _apiClient.put('/users/$userId', data: {
        'name': name,
        'email': email,
        'birthday': birthday,
        'gender': gender,
        'phone': phone,
        'password': password,
        'avatar': avatar,
        'role': role,
        'id': userId, // ID người dùng
      });

      if (response.statusCode == 200) {
        final dynamic content = response.data['content'];
        if (content != null) {
          return User.fromJson(content); // Trả về đối tượng User đã cập nhật
        } else {
          throw Exception("User update failed: Content is null");
        }
      } else {
        throw Exception("Failed to update user: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating user: $e");
    }
  }

  // Phương thức thay đổi mật khẩu
  Future<bool> changePassword(String userId, String oldPassword, String newPassword) async {
    try {
      final response = await _apiClient.put('/users/$userId/change-password', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      if (response.statusCode == 200) {
        return true; // Thành công
      } else {
        throw Exception("Failed to change password: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error changing password: $e");
    }
  }
}

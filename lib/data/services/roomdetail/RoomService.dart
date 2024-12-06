import '../../models/Comment.dart';
import '../../models/Location.dart';
import '../../models/Room.dart';
import '../api_client.dart';

class RoomService {
  final ApiClient _apiClient = ApiClient();

  // Phương thức lấy thông tin phòng
  Future<Room> fetchRoomDetails(String roomId) async {
    try {
      final response = await _apiClient.get('/rooms/room-by-id/$roomId');
      if (response.statusCode == 200) {
        final dynamic content = response.data['content'];
        if (content != null) {
          return Room.fromJson(content);
        } else {
          throw Exception("Room details content is null");
        }
      } else {
        throw Exception("Failed to fetch room details: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching room details: $e");
    }
  }

  // Phương thức lấy bình luận của phòng
  Future<List<Comment>> fetchRoomComments(String roomId) async {
    try {
      // Điều chỉnh API để lấy bình luận của phòng cụ thể
      final response = await _apiClient.get('/ratings?roomId=$roomId'); // Thêm tham số `roomId`
      if (response.statusCode == 200) {
        final dynamic content = response.data['content'];
        if (content != null && content is List) {
          return content.map((item) => Comment.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch room comments: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching room comments: $e");
    }
  }

  // Phương thức lấy ảnh của phòng
  Future<List<String>> fetchRoomImages(String roomId) async {
    try {
      // Điều chỉnh API để lấy ảnh của phòng cụ thể
      final response = await _apiClient.get('/room-images?roomId=$roomId'); // Thêm tham số `roomId`
      if (response.statusCode == 200) {
        final dynamic content = response.data['content'];
        if (content != null && content is List) {
          return content.map((item) => item['url'].toString()).toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to fetch room images: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching room images: $e");
    }
  }
  Future<Location> fetchLocationById(String locationId) async {
    try {
      final response = await _apiClient.get('/locations/$locationId');
      if (response.statusCode == 200) {
        final dynamic content = response.data['content'];
        if (content != null) {
          return Location.fromJson(content);
        } else {
          throw Exception("Location data is null");
        }
      } else {
        throw Exception("Failed to fetch location: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching location: $e");
    }
  }
}

import '../../models/Comment.dart';
import '../../models/room.dart';
import '../api_client.dart';

class RoomService {
  final ApiClient _apiClient = ApiClient();

  // Phương thức lấy tất cả thông tin liên quan đến phòng
  Future<RoomDetails> fetchRoomDetails(String roomId) async {
    try {
      final response = await _apiClient.get('/rooms/room-by-id/$roomId');
      if (response.statusCode != 200) {
        throw Exception("Failed to fetch room details: ${response.statusCode}");
      }

      final data = response.data;

      // Log toàn bộ dữ liệu trả về từ API
      print('API response data: $data');

      if (data == null || data['content'] == null) {
        throw Exception("Room details content is null");
      }

      final content = data['content'];

      // Log nội dung chính
      print('Room content: $content');

      if (content is! Map<String, dynamic>) {
        throw Exception("Content is not a Map<String, dynamic>");
      }

      final Room room = Room.fromJson(content);
      print('Room: $room');

      // Kiểm tra và log các trường images trước khi truy cập
      final images = content['images'];

      if (images == null) {
        print('Images is null');
      } else {
        print('Images: $images');
      }

      final List<String> imageUrls = images != null
          ? (images as List<dynamic>).map((item) {
              if (item == null || item['url'] == null) {
                print('Null item in images or missing url');
                throw Exception("Null item in images or missing url");
              }
              print('Processing image item: $item');
              return item['url'].toString();
            }).toList()
          : [];

      print('Image URLs: $imageUrls');

      return RoomDetails(
        room: room,
        images: imageUrls,
      );
    } catch (e) {
      print('Error fetching room details: $e');
      throw Exception("Error fetching room details: $e");
    }
  }

  // Phương thức lấy danh sách bình luận theo phòng
  Future<List<Comment>> fetchRoomComments(String roomId) async {
    try {
      final response = await _apiClient.get('/ratings/room/$roomId');
      if (response.statusCode != 200) {
        throw Exception("Failed to fetch comments: ${response.statusCode}");
      }

      final data = response.data;

      // Log toàn bộ dữ liệu trả về từ API
      print('API response data: $data');

      if (data == null || data['content'] == null) {
        throw Exception("Comments content is null");
      }

      final comments = data['content'] as List<dynamic>;

      // Chuyển đổi dữ liệu JSON thành danh sách Comment
      return comments
          .map((item) => Comment.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching comments: $e');
      throw Exception("Error fetching comments: $e");
    }
  }

  // Phương thức kiểm tra khả dụng của tòa nhà
  Future<bool> checkAvailability(
      String roomId, DateTime checkIn, DateTime checkOut) async {
    try {
      final response = await _apiClient.get('/rooms/room-by-id/$roomId');
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to fetch room bookings: ${response.statusCode}");
      }

      final data = response.data['content'];
      final bookings = data['bookings'] as List<dynamic>;

      for (var booking in bookings) {
        DateTime bookedCheckIn = DateTime.parse(booking['checkIn']);
        DateTime bookedCheckOut = DateTime.parse(booking['checkOut']);

        if ((checkIn.isBefore(bookedCheckOut) &&
                checkOut.isAfter(bookedCheckIn)) ||
            (checkIn.isAtSameMomentAs(bookedCheckIn) ||
                checkOut.isAtSameMomentAs(bookedCheckOut))) {
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error checking availability: $e');
      throw Exception("Error checking availability: $e");
    }
  }
}

class RoomDetails {
  final Room room;
  final List<String> images;

  RoomDetails({required this.room, required this.images});
}

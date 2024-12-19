import 'package:amazing_booking_app/data/models/room_image.dart';

import 'api_client.dart';

class RoomImageService {
  final ApiClient apiClient = ApiClient();

  Future<List<RoomImage>> getAllRoomImages() async {
    final response = await apiClient.get('/room-images');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['content'];
      return data.map((image) => RoomImage.fromJson(image)).toList();
    } else {
      throw Exception('Failed to load room images');
    }
  }
}

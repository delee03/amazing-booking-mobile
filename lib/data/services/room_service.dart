import 'package:amazing_booking_app/data/models/Room.dart';
import 'api_client.dart';

class RoomService {
  final ApiClient apiClient = ApiClient();

  Future<List<Room>> getAllRooms() async {
    final response = await apiClient.get('/rooms');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['content'];
      return data.map((room) => Room.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  Future<Room> getRoomById(String id) async {
    final response = await apiClient.get('/rooms/room-by-id/$id');
    if (response.statusCode == 200) {
      return Room.fromJson(response.data['content']);
    } else {
      throw Exception('Failed to load room');
    }
  }

  Future<List<Room>> getRoomsByLocation(String locationId) async {
    final response = await apiClient.get('/rooms/room-by-location/$locationId');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['content'];
      return data.map((room) => Room.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load rooms by location');
    }
  }
}

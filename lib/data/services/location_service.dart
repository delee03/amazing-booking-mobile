import 'package:amazing_booking_app/data/models/Location.dart';

import 'api_client.dart';

class LocationService {
  final ApiClient apiClient = ApiClient();

  Future<List<Location>> getAllLocations() async {
    final response = await apiClient.get('/locations');
    if (response.statusCode == 200) {
      List<dynamic> data = response.data['content'];
      return data.map((location) => Location.fromJson(location)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<Location> getLocationById(String id) async {
    final response = await apiClient.get('/locations/$id');
    if (response.statusCode == 200) {
      return Location.fromJson(response.data['content']);
    } else {
      throw Exception('Failed to load location');
    }
  }
}

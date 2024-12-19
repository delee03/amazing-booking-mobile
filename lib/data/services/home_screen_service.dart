import '../models/location.dart';
import '../models/hotel.dart';
import '../models/rating.dart';
import '../services/api_client.dart';

class HomeScreenService {
  final ApiClient _apiClient = ApiClient();

  Future<List<String>> fetchLocationNames() async {
    try {
      final response = await _apiClient.get('/locations');
      if (response.statusCode == 200) {
        final List<dynamic> content = response.data['content'];
        return content.map((e) => e['city'].toString()).toList();
      }
      throw Exception('Failed to load locations');
    } catch (error) {
      throw Exception('Error fetching locations: $error');
    }
  }

  Future<Map<String, Location>> fetchLocationsMap() async {
    try {
      final response = await _apiClient.get('/locations');
      if (response.statusCode == 200) {
        final List<dynamic> content = response.data['content'];
        return {
          for (var item in content)
            item['id']: Location.fromJson(item)
        };
      }
      throw Exception('Failed to load locations');
    } catch (error) {
      throw Exception('Error fetching locations: $error');
    }
  }

  Future<List<Hotel>> fetchTopHotels() async {
    try {
      final response = await _apiClient.get('/ratings');
      if (response.statusCode == 200) {
        final List<dynamic> content = response.data['content'];

        // Calculate ratings for each room
        final Map<String, List<int>> ratingMap = {};
        for (var item in content) {
          final Rating rating = Rating.fromJson(item);
          ratingMap.putIfAbsent(rating.roomId, () => []).add(rating.star);
        }

        // Fetch locations
        final locations = await fetchLocationsMap();

        // Process unique rooms
        final processedRoomIds = <String>{};
        final List<Hotel> hotels = [];

        for (var item in content) {
          final room = item['room'];

          if (!processedRoomIds.add(room['id'])) continue;

          final roomRatings = ratingMap[room['id']];
          if (roomRatings == null) continue;

          final averageStar = roomRatings.reduce((a, b) => a + b) / roomRatings.length;
          final locationName = locations[room['locationId']]?.city ?? 'Unknown';

          hotels.add(Hotel(
            id: room['id'],
            name: room['name'],
            description: room['description'],
            soLuong: room['soLuong'],
            soKhach: room['soKhach'],
            tienNghi: room['tienNghi'],
            price: (room['price'] is int)
                ? (room['price'] as int).toDouble()
                : room['price'],
            avatar: room['avatar'],
            averageStar: averageStar,
            locationName: locationName,
          ));
        }

        // Sort hotels by average star rating
        hotels.sort((a, b) => b.averageStar.compareTo(a.averageStar));

        return hotels.take(5).toList();
      }
      throw Exception('Failed to load ratings');
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }

  Future<List<dynamic>> fetchTopLocations() async {
    try {
      final apiClient = ApiClient();
      final data = await apiClient.fetchTopLocation();
      return data;
    } catch (e) {
      print('Error fetching top locations: $e');
      return [];
    }
  }
}
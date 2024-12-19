import 'api_client.dart';

//Lấy danh sách địa điểm
class DiscoverRoomApiService {
  Future<List<dynamic>> fetchRooms() async {
    try {
      final response = await ApiClient().get('/rooms');
      if (response.statusCode == 200) {
        return response.data['content'];
      } else {
        throw Exception('Failed to fetch rooms');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  double getAverageRating(Map<String, dynamic> room) {
    List ratings = room['ratings'] ?? [];
    if (ratings.isNotEmpty) {
      double average = ratings.fold<double>(
          0.0, (sum, rating) => sum + rating['star']) /
          ratings.length;
      return average;
    } else {
      return 0.0; // No ratings
    }
  }

  int getBookingsCount(Map<String, dynamic> room) {
    List bookings = room['bookings'] ?? [];
    return bookings.length;
  }

  int getAvailableRooms(Map<String, dynamic> room, DateTime checkIn, DateTime checkOut) {
    List bookings = room['bookings'] ?? [];
    bool isBooked = bookings.any((booking) {
      DateTime bookingCheckIn = DateTime.parse(booking['checkIn']);
      DateTime bookingCheckOut = DateTime.parse(booking['checkOut']);
      return !(bookingCheckOut.isBefore(checkIn) || bookingCheckIn.isAfter(checkOut));
    });
    return isBooked ? 0 : 1; // Return 0 if booked, 1 if available
  }
}


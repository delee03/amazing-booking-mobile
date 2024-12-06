import 'api_client.dart';

//Lấy danh sách địa điểm
class DiscoverRoomApiService {
  Future<List<dynamic>> fetchLocations() async {
    try {
      final response = await ApiClient().get('/locations');
      if (response.statusCode == 200) {
        return response.data['content'];
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

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

  Future<int> getBookings(String roomId) async {
    try {
      final response = await ApiClient().get('/booking');
      if (response.statusCode == 200) {
        // Lọc và đếm số lượt đặt cho phòng này
        int bookings = response.data['content']
            .where((booking) => booking['roomId'] == roomId)
            .length;
        return bookings;
      } else {
        throw Exception('Failed to fetch bookings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<double> getAverageRating(String roomId) async {
    try {
      final response = await ApiClient().get('/ratings');
      if (response.statusCode == 200) {
        List ratings = response.data['content']
            .where((rating) => rating['roomId'] == roomId)
            .toList();
        if (ratings.isNotEmpty) {
          double average =
              ratings.fold<double>(0.0, (sum, rating) => sum + rating['star']) /
                  ratings.length;
          return average;
        } else {
          return 0.0; // No ratings
        }
      } else {
        throw Exception('Failed to fetch ratings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> getAvailableRooms(
      String roomId, DateTime checkIn, DateTime checkOut) async {
    try {
      final response = await ApiClient().get('/booking');
      if (response.statusCode == 200) {
        // Lọc và kiểm tra nếu có bất kỳ booking nào trong khoảng thời gian checkIn và checkOut
        List<dynamic> bookings = response.data['content'].where((booking) {
          DateTime bookingCheckIn = DateTime.parse(booking['checkIn']);
          DateTime bookingCheckOut = DateTime.parse(booking['checkOut']);
          return booking['roomId'] == roomId &&
              !(bookingCheckOut.isBefore(checkIn) ||
                  bookingCheckIn.isAfter(checkOut));
        }).toList(); // Nếu có bất kỳ đặt phòng nào trong khoảng thời gian này, coi như tất cả phòng đều đã được đặt
        if (bookings.isNotEmpty) {
          return 0; // Tất cả phòng đã được đặt
        } else {
          return 1; // Tất cả phòng đều trống
        }
      } else {
        throw Exception('Failed to fetch bookings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> fetchAllBookings() async {
    try {
      final response = await ApiClient().get('/booking');
      if (response.statusCode == 200) {
        return response.data['content'];
      } else {
        throw Exception('Failed to fetch bookings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

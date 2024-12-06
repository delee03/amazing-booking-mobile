import 'package:flutter/material.dart';
import '../../../data/models/Booking.dart';
import '../../../data/services/BookingService.dart';

class BookingHistoryScreen extends StatelessWidget {
  final BookingService _bookingService = BookingService(); // Service để gọi API
  final String userId; // Nhận userId để lấy lịch sử đặt phòng

  BookingHistoryScreen({required this.userId}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lịch sử đặt phòng",
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: FutureBuilder<List<Booking>>(
        future: _fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Có lỗi xảy ra: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Không có lịch sử đặt phòng.'),
            );
          } else {
            final bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("Phòng: ${booking.roomId}"),
                    subtitle: Text(
                      "Ngày đặt: ${DateTime.parse(booking.checkIn as String).toLocal()}\n"
                          "Ngày hết hạn: ${DateTime.parse(booking.checkOut as String).toLocal()}",
                    ),
                    trailing: Text(
                      booking.paymentMethod,
                      style: TextStyle(
                        color: booking.paymentStatus == "Confirmed"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    onTap: () {
                      // Xử lý khi nhấn vào item (ví dụ: chuyển đến chi tiết đặt phòng)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailScreen(booking: booking),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Lấy danh sách đặt phòng từ API
  Future<List<Booking>> _fetchBookings() async {
    try {
      return await _bookingService.fetchBookingsByUserId(userId);
    } catch (e) {
      throw Exception("Error fetching bookings: $e");
    }
  }
}

// Màn hình chi tiết đặt phòng (ví dụ cơ bản)
class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  BookingDetailScreen({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết đặt phòng"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Phòng: ${booking.roomId}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Ngày đặt: ${DateTime.parse(booking.checkIn as String).toLocal()}"),
            Text("Ngày hết hạn: ${DateTime.parse(booking.checkOut as String).toLocal()}"),
            SizedBox(height: 8),
            Text("Trạng thái: ${booking.paymentStatus}"),
          ],
        ),
      ),
    );
  }
}

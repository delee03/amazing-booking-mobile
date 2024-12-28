import 'package:amazing_booking_app/data/models/booking/booking.dart';
import 'package:amazing_booking_app/data/services/user_booking/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booking_detail_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  final String userId;
  final String token;

  BookingHistoryScreen({super.key, required this.userId, required this.token});

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final BookingService _bookingService = BookingService();
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchBookings();
  }

  Future<void> _refreshBookings() async {
    setState(() {
      _bookingsFuture = _fetchBookings();
    });
  }

  String _getBookingStatus(Booking booking) {
    final currentDate = DateTime.now();
    if (!booking.paymentStatus) {
      return "Chưa thanh toán";
    } else if (booking.checkOut.isBefore(currentDate)) {
      return "Đã hết hạn";
    } else {
      return "Khả dụng";
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Chưa thanh toán":
        return Colors.red;
      case "Đã hết hạn":
        return Colors.orange;
      case "Khả dụng":
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lịch sử đặt phòng",
          style: TextStyle(color: Color(0xFFEF4444)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBookings,
        child: FutureBuilder<List<Booking>>(
          future: _bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có lịch sử đặt phòng.'));
            } else {
              final bookings = snapshot.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final status = _getBookingStatus(booking);
                  final statusColor = _getStatusColor(status);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.room.name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            booking.room.address,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "Ngày đặt: ${DateFormat('dd/MM/yyyy').format(booking.checkIn.toLocal())}\n"
                            "Ngày hết hạn: ${DateFormat('dd/MM/yyyy').format(booking.checkOut.toLocal())}",
                      ),
                      trailing: Text(
                        status,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailScreen(
                              booking: booking, token: widget.token, // Truyền đối tượng booking
                            ),
                          ),
                        );
                        // Làm mới lịch sử đặt phòng nếu cần
                        if (result == true) {
                          _refreshBookings();
                        }
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Booking>> _fetchBookings() async {
    try {
      List<Booking> bookings = await _bookingService.fetchBookingsByUserId(widget.userId, widget.token);
      bookings.sort((a, b) => b.checkIn.compareTo(a.checkIn)); // Sắp xếp theo ngày check-in từ gần nhất đến xa nhất
      return bookings;
    } catch (e) {
      throw Exception("Error fetching bookings: $e");
    }
  }
}

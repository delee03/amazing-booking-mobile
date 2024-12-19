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
      body: FutureBuilder<List<Booking>>(
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
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("Phòng: ${booking.room.name}"),
                    subtitle: Text(
                      "Ngày đặt: ${DateFormat('dd/MM/yyyy').format(booking.checkIn.toLocal())}\n"
                      "Ngày hết hạn: ${DateFormat('dd/MM/yyyy').format(booking.checkOut.toLocal())}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          booking.paymentMethod,
                          style: TextStyle(
                            color: booking.paymentStatus
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        if (!booking
                            .paymentStatus) // Nếu chưa thanh toán, hiện nút xóa
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Xác nhận xóa"),
                                    content: const Text(
                                        "Bạn có chắc chắn muốn xóa booking này không?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Hủy"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context); // Đóng dialog
                                          try {
                                            await _bookingService.deleteBooking(
                                                booking.id, widget.token);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Xóa booking thành công!")),
                                            );
                                            // Tải lại danh sách bookings
                                            setState(() {
                                              _bookingsFuture =
                                                  _fetchBookings();
                                            });
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Lỗi khi xóa booking: $e")),
                                            );
                                          }
                                        },
                                        child: const Text("Xóa"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailScreen(
                            booking: booking, // Truyền đối tượng booking
                          ),
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

  Future<List<Booking>> _fetchBookings() async {
    try {
      List<Booking> bookings = await _bookingService.fetchBookingsByUserId(
          widget.userId, widget.token);
      bookings.sort((a, b) => b.checkIn.compareTo(
          a.checkIn)); // Sắp xếp theo ngày check-in từ gần nhất đến xa nhất
      return bookings;
    } catch (e) {
      throw Exception("Error fetching bookings: $e");
    }
  }
}

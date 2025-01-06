import 'package:amazing_booking_app/data/models/booking/booking.dart';
import 'package:amazing_booking_app/data/services/user_booking/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'booking_detail_screen.dart';

enum BookingStatusList {
  expired,
  unpaid,
  available,
  unknown
}

class BookingHistoryScreen extends StatefulWidget {
  final String userId;
  final String token;

  const BookingHistoryScreen({
    super.key,
    required this.userId,
    required this.token
  });

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final BookingService _bookingService = BookingService();
  late Future<List<Booking>> _bookingsFuture;
  Timer? _refreshTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = _fetchBookings();
    // Tự động refresh mỗi 5 phút
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _refreshBookings();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  BookingStatusList _getBookingStatus(Booking booking) {
    try {
      final currentDate = DateTime.now();

      // Kiểm tra null safety
      if (booking.checkOut == null || booking.checkIn == null) {
        return BookingStatusList.unknown;
      }

      // Ưu tiên kiểm tra hết hạn trước
      if (booking.checkOut.isBefore(currentDate)) {
        return BookingStatusList.expired;
      }

      // Sau đó kiểm tra thanh toán
      if (!booking.paymentStatus) {
        return BookingStatusList.unpaid;
      }

      return BookingStatusList.available;
    } catch (e) {
      debugPrint('Error getting booking status: $e');
      return BookingStatusList.unknown;
    }
  }

  String _getStatusText(BookingStatusList status) {
    switch (status) {
      case BookingStatusList.expired:
        return "Đã hết hạn";
      case BookingStatusList.unpaid:
        return "Chưa thanh toán";
      case BookingStatusList.available:
        return "Khả dụng";
      case BookingStatusList.unknown:
        return "Không xác định";
    }
  }

  Color _getStatusColor(BookingStatusList status) {
    switch (status) {
      case BookingStatusList.expired:
        return Colors.red;
      case BookingStatusList.unpaid:
        return Colors.orange;
      case BookingStatusList.available:
        return Colors.green;
      case BookingStatusList.unknown:
        return Colors.grey;
    }
  }

  Future<void> _refreshBookings() async {
    if (_isLoading) return; // Tránh refresh nhiều lần

    setState(() {
      _isLoading = true;
    });

    try {
      _bookingsFuture = _fetchBookings();
    } catch (e) {
      _showErrorDialog('Không thể làm mới danh sách: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(Booking booking) {
    final status = _getBookingStatus(booking);
    final statusText = _getStatusText(status);
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToDetail(booking),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.room?.name ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                booking.room?.address ?? 'Không có địa chỉ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDateInfo(
                      'Check-in',
                      booking.checkIn,
                    ),
                  ),
                  Expanded(
                    child: _buildDateInfo(
                      'Check-out',
                      booking.checkOut,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          date != null
              ? DateFormat('dd/MM/yyyy').format(date.toLocal())
              : 'N/A',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToDetail(Booking booking) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailScreen(
            booking: booking,
            token: widget.token,
          ),
        ),
      );

      if (result == true) {
        await _refreshBookings();
      }
    } catch (e) {
      _showErrorDialog('Không thể mở chi tiết đặt phòng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lịch sử đặt phòng",
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEF4444)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshBookings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBookings,
        child: FutureBuilder<List<Booking>>(
          future: _bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Có lỗi xảy ra: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshBookings,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.history,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Chưa có lịch sử đặt phòng',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            final bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) => _buildBookingItem(bookings[index]),
            );
          },
        ),
      ),
    );
  }

  Future<List<Booking>> _fetchBookings() async {
    try {
      List<Booking> bookings = await _bookingService.fetchBookingsByUserId(
        widget.userId,
        widget.token,
      );

      // Sắp xếp theo trạng thái và ngày check-in
      bookings.sort((a, b) {
        // Ưu tiên sắp xếp theo trạng thái
        final statusA = _getBookingStatus(a);
        final statusB = _getBookingStatus(b);

        if (statusA != statusB) {
          // Sắp xếp theo thứ tự: hết hạn > chưa thanh toán > khả dụng > không xác định
          return statusA.index.compareTo(statusB.index);
        }

        // Nếu cùng trạng thái, sắp xếp theo ngày check-in từ gần nhất đến xa nhất
        return b.checkIn.compareTo(a.checkIn);
      });

      return bookings;
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      throw Exception("Không thể tải lịch sử đặt phòng: $e");
    }
  }
}
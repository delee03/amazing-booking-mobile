import 'package:flutter/material.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/services/roomdetail/RoomService.dart';
import '../../widgets/booking/booking_room_info.dart';
import '../../widgets/booking/booking_cancellation_policy.dart';
import '../../widgets/booking/booking_time_info.dart';
import '../../widgets/booking/booking_price_details.dart';
import '../../widgets/booking/booking_payment_methods.dart';

class BookingScreen extends StatefulWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;
  final String roomId;
  final int soKhach;

  const BookingScreen({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.roomId,
    required this.soKhach,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final RoomService _roomService = RoomService();
  final BookingService _bookingService = BookingService();
  String _paymentMethod = "MOMO";
  late Future<RoomDetails> _roomDetailsFuture;
  bool _isBooking = false;
  @override
  void initState() {
    super.initState();
    _roomDetailsFuture = _roomService.fetchRoomDetails(widget.roomId);
  }

  Future<void> _handleBooking() async {
    setState(() {
      _isBooking = true; // Đặt trạng thái là đang booking
    });
    try {
      final booking = await _bookingService.createBooking(
        paymentStatus: true,
        totalPrice: widget.totalPrice,
        roomId: widget.roomId,
        checkIn: widget.checkIn,
        checkOut: widget.checkOut,
        guests: widget.soKhach,
        paymentMethod: _paymentMethod,
        context: context,
      );

      if (booking != null && mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    } finally {
      setState(() {
        _isBooking = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Đặt phòng thành công!"),
        content: const Text("Cảm ơn bạn đã sử dụng dịch vụ."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Xác nhận thanh toán",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<RoomDetails>(
        future: _roomDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy thông tin phòng.'));
          }

          final roomDetails = snapshot.data!;
          final room = roomDetails.room;

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BookingRoomInfo(
                            imagesFuture: Future.value(roomDetails.images),
                            roomName: room.name,
                          ),
                          const Divider(),
                          const BookingCancellationPolicy(),
                          const Divider(),
                          BookingTimeInfo(
                              checkIn: widget.checkIn,
                              checkOut: widget.checkOut),
                          const Divider(),
                          BookingPriceDetails(
                            checkIn: widget.checkIn,
                            checkOut: widget.checkOut,
                            totalPrice: widget.totalPrice,
                            pricePerDay: room.price.toInt(),
                            maxGues: widget.soKhach,
                          ),
                          const Divider(),
                          BookingPaymentMethods(
                            onPaymentMethodChanged: (method) {
                              setState(() => _paymentMethod = method);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _isBooking
                          ? null
                          : _handleBooking, // Vô hiệu hóa button khi đang booking
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isBooking // Hiển thị loading indicator hoặc text
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Xác nhận thanh toán",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
              if (_isBooking) // Overlay loading indicator lên toàn màn hình
                const Opacity(
                  opacity: 0.5,
                  child: ModalBarrier(dismissible: false, color: Colors.grey),
                ),
              if (_isBooking)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}

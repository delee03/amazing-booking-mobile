import 'package:flutter/material.dart';
import '../../../data/services/BookingService.dart';
import '../../../data/services/roomdetail/RoomService.dart';
import '../../../data/models/Room.dart';
import '../../widgets/booking/booking_room_info.dart';
import '../../widgets/booking/booking_cancellation_policy.dart';
import '../../widgets/booking/booking_time_info.dart';
import '../../widgets/booking/booking_price_details.dart';
import '../../widgets/booking/booking_payment_methods.dart';

class BookingScreen extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;
  final String roomId;
  final int soKhach;
  final RoomService _roomService = RoomService();
  String paymentMethod = "CREDIT_CARD"; // Giá trị mặc định
  BookingScreen({
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
    required this.roomId,
    required this.soKhach,
  });

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
      body: FutureBuilder<Room>(
        future: _roomService.fetchRoomDetails(roomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy thông tin phòng.'));
          }

          // Dữ liệu phòng đã tải
          Room room = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị thông tin và hình ảnh phòng
                      BookingRoomInfo(
                        imagesFuture: _roomService.fetchRoomImages(room.id),
                        roomName: room.name,
                      ),
                      const Divider(),
                      BookingCancellationPolicy(),
                      const Divider(),
                      // Hiển thị thời gian đặt phòng
                      BookingTimeInfo(checkIn: checkIn, checkOut: checkOut),
                      const Divider(),
                      // Hiển thị chi tiết giá
                      BookingPriceDetails(
                        checkIn: checkIn,
                        checkOut: checkOut,
                        totalPrice: totalPrice,
                        pricePerDay: room.price.toInt(),
                        maxGues: soKhach,
                      ),
                      const Divider(),
                      BookingPaymentMethods(onPaymentMethodChanged: (selectedMethod) {
                        paymentMethod = selectedMethod; // Cập nhật phương thức thanh toán
                      },),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444), // Màu nút #EF4444
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final bookingService = BookingService();
                      await bookingService.createBooking(
                        paymentStatus: true,
                        totalPrice: totalPrice,
                        roomId: roomId,
                        checkIn: checkIn,
                        checkOut: checkOut,
                        guests: soKhach, // Thay bằng số khách thực tế
                        paymentMethod: paymentMethod, // Thay bằng phương thức thanh toán thực tế
                      );

                      // Hiển thị thông báo thành công
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Đặt phòng thành công!"),
                            content: const Text("Cảm ơn bạn đã sử dụng dịch vụ."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context); // Quay lại RoomDetailScreen
                                },
                                child: const Text("Đóng"),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      // Hiển thị lỗi
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Lỗi"),
                            content: Text("Không thể đặt phòng: $e"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Đóng"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    "Xác nhận thanh toán",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

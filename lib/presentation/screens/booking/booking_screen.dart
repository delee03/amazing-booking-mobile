import 'package:flutter/material.dart';
import '../../widgets/booking/booking_room_info.dart';
import '../../widgets/booking/booking_cancellation_policy.dart';
import '../../widgets/booking/booking_time_info.dart';
import '../../widgets/booking/booking_price_details.dart';
import '../../widgets/booking/booking_payment_methods.dart';

class BookingScreen extends StatelessWidget {
  final String roomName;
  final String roomImage;
  final DateTime checkIn;
  final DateTime checkOut;
  final int totalPrice;

  BookingScreen({
    required this.roomName,
    required this.roomImage,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác nhận thanh toán", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingRoomInfo(roomName: roomName, roomImage: roomImage),
                  Divider(),
                  BookingCancellationPolicy(),
                  Divider(),
                  BookingTimeInfo(checkIn: checkIn, checkOut: checkOut),
                  Divider(),
                  BookingPriceDetails(totalPrice: totalPrice),
                  Divider(),
                  BookingPaymentMethods(),
                ],
              ),
            ),
          ),
          // Thêm nút xác nhận thanh toán
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444), // Màu nút #EF4444
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Xử lý khi nhấn nút "Xác nhận thanh toán"
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Đặt phòng thành công!"),
                      content: Text("Cảm ơn bạn đã sử dụng dịch vụ."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context); // Quay lại RoomDetailScreen
                          },
                          child: Text("Đóng"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "Xác nhận thanh toán",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

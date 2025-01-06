import 'package:amazing_booking_app/presentation/screens/profile/route_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/booking/booking.dart';
import '../../../data/services/api_client.dart';
import '../../../data/services/user_booking/booking_service.dart';
import '../../../data/services/vnpay_service.dart';
import 'edit_booking_screen.dart';
import 'room_review_screen.dart'; // Import RoomReviewScreen

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;
  final String token;

  const BookingDetailScreen(
      {super.key, required this.booking, required this.token});

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool canReview = false;
  final BookingService _bookingService = BookingService();
  late String _selectedPaymentMethod;
  @override
  void initState() {
    super.initState();
    _checkUserRating();
    _selectedPaymentMethod = widget.booking.paymentMethod;
  }

  void _checkUserRating() async {
    try {
      final response = await ApiClient().get(
        '/ratings/user/${widget.booking.user!.id}',
        queryParameters: null,
      );

      if (response.statusCode == 200) {
        final ratings = response.data['content'];
        final hasReviewed =
            ratings.any((rating) => rating['roomId'] == widget.booking.room.id);

        setState(() {
          final today = DateTime.now();
          canReview = !hasReviewed &&
              widget.booking.paymentStatus &&
              today.isAfter(
                  widget.booking.checkIn.subtract(Duration(days: 1))) &&
              today.isBefore(widget.booking.checkOut.add(Duration(days: 31)));
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí không được bật.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền truy cập vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

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
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tên khách sạn:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            child: Text(
                              widget.booking.room.name,
                              style: const TextStyle(fontSize: 16),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Địa chỉ:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                            child: Text(
                              widget.booking.room.address,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.right,
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ngày nhận phòng:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(widget.booking.checkIn.toLocal()),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ngày trả phòng:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(widget.booking.checkOut.toLocal()),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tổng giá:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                                .format(widget.booking.totalPrice),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Số khách:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.booking.guests.toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Phương thức thanh toán:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.booking.paymentMethod,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Trạng thái thanh toán:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.booking.paymentStatus
                                ? 'Đã thanh toán'
                                : 'Chưa thanh toán',
                            style: TextStyle(
                                fontSize: 16,
                                color: widget.booking.paymentStatus
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!widget.booking.paymentStatus) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Xử lý logic thanh toán
                        _handlePayment(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                      child: const Text("Thanh toán"),
                    ),
                  ),
                  const SizedBox(width: 16), // Thêm khoảng cách giữa các nút
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Hiển thị dialog xác nhận xóa
                        _showDeleteDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                      child: const Text("Xóa đặt phòng"),
                    ),
                  ),
                  const SizedBox(width: 16), // Thêm khoảng cách giữa các nút
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBookingScreen(
                              booking: widget.booking,
                              token: widget.token,
                            ),
                          ),
                        );
                        if (result == true) {
                          Navigator.pop(context, true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      child: const Text("Chỉnh sửa"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //if (canReview) // Nút đánh giá phòng
            FloatingActionButton(
              heroTag: "reviewButton",
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              child: const Icon(Icons.rate_review),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomReviewScreen(
                      booking: widget.booking,
                      token: widget.token,
                    ),
                  ),
                );
                if (result == true) {
                  _checkUserRating(); // Làm mới lại trạng thái đánh giá khi quay lại
                }
              },
            ),
          const SizedBox(height: 16), // Khoảng cách giữa các nút
          FloatingActionButton(
            heroTag: "directionsButton",
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.directions),
            onPressed: () async {
              try {
                // Lấy tọa độ hiện tại của người dùng
                final position = await _determinePosition();

                // Chuyển đến màn hình chỉ đường
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteMapScreen(
                      destinationLat: double.parse(widget.booking.room.latitude),
                      destinationLng: double.parse(widget.booking.room.longitude),
                    ),
                  ),
                );
              } catch (e) {
                // Thông báo lỗi nếu không lấy được vị trí
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi khi lấy vị trí: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _handlePayment(BuildContext context) async {
    try {
      final vnPayService = VNPayService();
      await vnPayService.createPayment(context, widget.booking);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yêu cầu thanh toán đã được gửi!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi gửi yêu cầu thanh toán: $e")),
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc chắn muốn xóa booking này không?"),
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
                      widget.booking.id, widget.token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Xóa booking thành công!")),
                  );
                  Navigator.pop(context, true); // Trả về kết quả thành công
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi khi xóa booking: $e")),
                  );
                }
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }
}

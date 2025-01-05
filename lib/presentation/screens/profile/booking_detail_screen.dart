import 'package:amazing_booking_app/presentation/widgets/profile/booking_detail_widgets.dart';
import 'package:amazing_booking_app/presentation/widgets/profile/booking_status.dart';
import 'package:amazing_booking_app/presentation/widgets/profile/booking_status_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../data/models/booking/booking.dart';
import '../../../data/services/api_client.dart';
import '../../../data/services/user_booking/booking_service.dart';
import 'edit_booking_screen.dart';
import 'room_review_screen.dart';
import 'route_map_screen.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;
  final String token;

  const BookingDetailScreen(
      {Key? key, required this.booking, required this.token})
      : super(key: key);

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool canReview = false;
  bool isLoading = false;
  String errorMessage = '';
  late BookingStatus bookingStatus;
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    _updateBookingStatus();
    await _checkUserRating();
  }

  void _updateBookingStatus() {
    setState(() {
      bookingStatus = BookingStatusHelper.getBookingStatus(
          widget.booking.checkIn,
          widget.booking.checkOut,
          widget.booking.paymentStatus);
    });
  }

  Future<void> _checkUserRating() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      final response = await ApiClient().get(
        '/ratings/user/${widget.booking.user!.id}',
        queryParameters: null,
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final ratings = response.data['content'] as List;
        final hasReviewed = ratings.any((rating) =>
            rating['roomId'] == widget.booking.room.id &&
            rating['userId'] == widget.booking.user!.id);

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
      setState(() => errorMessage = 'Lỗi kiểm tra đánh giá: $e');
      _showErrorSnackBar('Không thể kiểm tra trạng thái đánh giá');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Dịch vụ vị trí không được bật');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Quyền truy cập vị trí bị từ chối');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Quyền truy cập vị trí bị từ chối vĩnh viễn');
      }

      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      _showErrorSnackBar(e.toString());
      return null;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _handleDelete() async {
    try {
      await _bookingService.deleteBooking(widget.booking.id, widget.token);
      _showSuccessSnackBar('Xóa đặt phòng thành công');
      Navigator.pop(context, true);
    } catch (e) {
      _showErrorSnackBar('Lỗi khi xóa đặt phòng: $e');
    }
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa đặt phòng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDelete();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToEdit() async {
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
  }

  Future<void> _navigateToReview() async {
    if (!canReview) return;

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
      await _checkUserRating();
    }
  }

  Future<void> _navigateToMap() async {
    try {
      final position = await _determinePosition();
      if (position == null) return;

      if (!mounted) return;

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
      _showErrorSnackBar('Không thể mở bản đồ: $e');
    }
  }

  Widget _buildBookingInfo() {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thông tin đặt phòng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BookingDetailWidgets.buildStatusBadge(bookingStatus),
              ],
            ),
            SizedBox(height: 16),
            BookingDetailWidgets.buildInfoRow(
              'Tên khách sạn:',
              widget.booking.room.name,
            ),
            BookingDetailWidgets.buildInfoRow(
              'Địa chỉ:',
              widget.booking.room.address,
            ),
            BookingDetailWidgets.buildInfoRow(
              'Ngày nhận phòng:',
              dateFormat.format(widget.booking.checkIn.toLocal()),
            ),
            BookingDetailWidgets.buildInfoRow(
              'Ngày trả phòng:',
              dateFormat.format(widget.booking.checkOut.toLocal()),
            ),
            BookingDetailWidgets.buildInfoRow(
              'Tổng giá:',
              currencyFormat.format(widget.booking.totalPrice),
              valueStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            BookingDetailWidgets.buildInfoRow(
              'Số khách:',
              widget.booking.guests.toString(),
            ),
            BookingDetailWidgets.buildInfoRow(
              'Trạng thái thanh toán:',
              widget.booking.paymentStatus
                  ? 'Đã thanh toán'
                  : 'Chưa thanh toán',
              valueStyle: TextStyle(
                fontSize: 16,
                color: widget.booking.paymentStatus ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (bookingStatus == BookingStatus.unpaid) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: BookingDetailWidgets.buildActionButtons(
          context,
          onDelete: _showDeleteConfirmDialog,
          onEdit: _navigateToEdit,
          isUnpaid: true,
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canReview)
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: FloatingActionButton(
              heroTag: 'reviewButton',
              backgroundColor: Colors.red,
              onPressed: _navigateToReview,
              child: Icon(Icons.rate_review),
            ),
          ),
        FloatingActionButton(
          heroTag: 'mapButton',
          backgroundColor: Colors.blue,
          onPressed: _navigateToMap,
          child: Icon(Icons.directions),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đặt phòng'),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đã có lỗi xảy ra',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(errorMessage),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeScreen,
                        child: Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildBookingInfo(),
                      _buildActionButtons(),
                    ],
                  ),
                ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/booking/booking.dart';
import '../../../data/services/api_client.dart';
import 'booking_history_screen.dart';

final List<Map<String, dynamic>> paymentMethods = [
  {
    "label": "Ví điện tử MoMo",
    "value": "MOMO",
    "icon": "assets/images/momo.png",
  },
  {
    "label": "VNPay",
    "value": "VNPAY",
    "icon": "assets/images/vnpay.png",
  },
  {
    "label": "PayPal",
    "value": "PAYPAL",
    "icon": Icons.paypal,
  },
  {
    "label": "Chuyển khoản ngân hàng",
    "value": "BANK_TRANSFER",
    "icon": Icons.account_balance,
  },
  {
    "label": "Khác",
    "value": "OTHER",
    "icon": Icons.more_horiz,
  },
];

class EditBookingScreen extends StatefulWidget {
  final Booking booking;
  final String token;

  EditBookingScreen({super.key, required this.booking, required this.token});

  @override
  _EditBookingScreenState createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  late int _totalPrice;
  late int _guests;
  late String _paymentMethod;
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  late TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();

  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi', symbol: '₫');
  @override
  void initState() {
    super.initState();
    _checkInDate = widget.booking.checkIn;
    _checkOutDate = widget.booking.checkOut;
    _totalPrice = widget.booking.totalPrice;
    _guests = widget.booking.guests;
    _paymentMethod = widget.booking.paymentMethod;
    _checkInController.text = DateFormat('dd/MM/yyyy').format(_checkInDate);
    _checkOutController.text = DateFormat('dd/MM/yyyy').format(_checkOutDate);
    _guestsController.text = _guests.toString();
    _totalPriceController.text = _totalPrice.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateTotalPrice());
  }

  Future<bool> _isBookingAvailable(DateTime checkIn, DateTime checkOut) async {
    try {
      final response = await ApiClient().get(
        '/rooms/room-by-id/${widget.booking.room.id}',
      );

      if (response.statusCode == 200) {
        final room = response.data['content'];
        final bookings = room['bookings'] as List;
        for (var booking in bookings) {
          if (booking['id'] == widget.booking.id) {
            continue; // Bỏ qua booking hiện tại
          }
          final bookingCheckIn = DateTime.parse(booking['checkIn']);
          final bookingCheckOut = DateTime.parse(booking['checkOut']);
          if ((checkIn.isBefore(bookingCheckOut) &&
                  checkOut.isAfter(bookingCheckIn)) ||
              (checkIn.isAtSameMomentAs(bookingCheckIn) &&
                  checkOut.isAtSameMomentAs(bookingCheckOut))) {
            return false;
          }
        }
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Lỗi khi kiểm tra phòng: ${response.statusCode}")),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kiểm tra phòng: $e")),
      );
      return false;
    }
  }

  void _calculateTotalPrice() {
    final int nights = _calculateNights(_checkInDate, _checkOutDate);
    print('CheckIn: $_checkInDate, CheckOut: $_checkOutDate, Nights: $nights');

    setState(() {
      // Đảm bảo rằng số đêm ít nhất là 1 để không ảnh hưởng đến tính toán giá
      _totalPrice = widget.booking.room.price * nights;
      _totalPriceController.text =
          _totalPrice.toString(); // Cập nhật TextEditingController
      print('Total Price: $_totalPrice');
    });
  }

  int _calculateNights(DateTime checkIn, DateTime checkOut) {
    final duration = checkOut.difference(checkIn);
    final nights =
        duration.inHours / 24; // Chia theo giờ để đảm bảo tính chính xác
    return nights.ceil(); // Sử dụng ceil để làm tròn lên
  }

  Future<void> _updateBooking() async {
    if (_formKey.currentState!.validate()) {
      final bookingData = {
        "checkIn": _checkInDate.toIso8601String(),
        "checkOut": _checkOutDate.toIso8601String(),
        "totalPrice": _totalPrice,
        "userId": widget.booking.user?.id,
        "roomId": widget.booking.room.id,
        "guests": _guests,
        "paymentMethod": _paymentMethod,
        "paymentStatus": widget.booking.paymentStatus,
      };

      try {
        // Đảm bảo token được thiết lập trước khi thực hiện yêu cầu
        ApiClient().setAuthorizationToken(widget.token);

        // Thực hiện yêu cầu PUT với dữ liệu và token
        final response = await ApiClient().put(
          '/booking/${widget.booking.id}',
          data: bookingData,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cập nhật booking thành công!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingHistoryScreen(
                userId: widget.booking.user!.id,
                token: widget.token,
              ),
            ),
          );
        } else {
          print("Server Response: ${response.data}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Cập nhật booking thất bại, vui lòng thử lại! Lỗi: ${response.statusCode}")),
          );
        }
      } catch (e) {
        print("Lỗi: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e")),
        );
      }
    }
  }

  void _increaseGuests() {
    setState(() {
      _guests++;
      _guestsController.text = _guests.toString();
      print('Guests increased: $_guests');
    });
  }

  void _decreaseGuests() {
    setState(() {
      if (_guests > 1) {
        _guests--;
        _guestsController.text =
            _guests.toString(); // Cập nhật giá trị của TextEditingController
        print('Guests decreased: $_guests');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa booking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ngày nhận phòng",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      height:
                          8), // Thêm khoảng cách giữa tiêu đề và nút chọn ngày
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _checkInDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null &&
                          selectedDate.isBefore(_checkOutDate)) {
                        final isAvailable = await _isBookingAvailable(
                            selectedDate, _checkOutDate);
                        if (isAvailable) {
                          setState(() {
                            _checkInDate = selectedDate;
                            _checkInController.text =
                                DateFormat('dd/MM/yyyy').format(_checkInDate);
                            _calculateTotalPrice();
                            print('Selected CheckIn Date: $_checkInDate');
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Khoảng thời gian đã chọn không khả dụng.")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Ngày nhận phòng phải trước ngày trả phòng.")),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity, // Kéo dài ra vừa màn hình
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _checkInController.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Khoảng cách giữa các phần
                  const Text(
                    "Ngày trả phòng",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      height:
                          8), // Thêm khoảng cách giữa tiêu đề và nút chọn ngày
                  GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _checkOutDate,
                        firstDate: _checkInDate.add(const Duration(days: 1)),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null &&
                          selectedDate.isAfter(_checkInDate)) {
                        final isAvailable = await _isBookingAvailable(
                            _checkInDate, selectedDate);
                        if (isAvailable) {
                          setState(() {
                            _checkOutDate = selectedDate;
                            _checkOutController.text =
                                DateFormat('dd/MM/yyyy').format(_checkOutDate);
                            _calculateTotalPrice();
                            print('Selected CheckOut Date: $_checkOutDate');
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Khoảng thời gian đã chọn không khả dụng.")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Ngày trả phòng phải sau ngày nhận phòng.")),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity, // Kéo dài ra vừa màn hình
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _checkOutController.text,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tổng giá",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity, // Kéo dài ra vừa màn hình
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      currencyFormat.format(_totalPrice),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Số khách",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      height:
                          8), // Thêm khoảng cách giữa tiêu đề và ô nhập số khách
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 0), // Giảm chiều cao
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _decreaseGuests, // Gọi hàm giảm số khách
                        ),
                        SizedBox(
                          width: 50,
                          child: TextFormField(
                            controller:
                                _guestsController, // Sử dụng TextEditingController
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            readOnly:
                                true, // Làm cho trường chỉ đọc để tránh xung đột
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _increaseGuests, // Gọi hàm tăng số khách
                        ),
                      ],
                    ),
                  ),
                  // Chuyển thông báo ra ngoài khung
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _guests > widget.booking.room.soKhach
                          ? 'Số khách không được quá ${widget.booking.room.soKhach}'
                          : '',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Phương thức thanh toán",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _paymentMethod,
                      decoration:
                          const InputDecoration.collapsed(hintText: null),
                      items: paymentMethods.map((method) {
                        return DropdownMenuItem<String>(
                          value: method['value'],
                          child: Row(
                            children: [
                              method['icon'] is IconData
                                  ? Icon(method['icon'])
                                  : Image.asset(
                                      method['icon'],
                                      width: 24,
                                      height: 24,
                                    ),
                              const SizedBox(width: 8),
                              Text(method['label']),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      Colors.blue, // Màu chữ trắng để tăng tương phản
                  side: const BorderSide(color: Colors.grey, width: 1), // Khung
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Đệm để tăng kích thước
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Bo góc
                  ),
                ),
                onPressed: () {
                  // Kiểm tra số khách hợp lệ trước khi cho phép đặt phòng
                  if (_guests <= widget.booking.room.soKhach) {
                    _updateBooking();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Số khách không được quá ${widget.booking.room.soKhach}'),
                      ),
                    );
                  }
                },
                child: const Text("Cập nhật booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

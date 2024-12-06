import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../screens/booking/booking_screen.dart';

class BookRoomSection extends StatefulWidget {
  final String roomId;
  final int maxGuests;
  final int Price;

  const BookRoomSection({
    required this.roomId,
    required this.maxGuests,
    required int totalPrice,
    required int soKhach,
    required DateTime checkIn,
    required DateTime checkOut,
    required Null Function(DateTime selectedCheckIn, DateTime selectedCheckOut, int guests) onDateChanged,
    required this.Price,
  });

  @override
  _BookRoomSectionState createState() => _BookRoomSectionState();
}

class _BookRoomSectionState extends State<BookRoomSection> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _selectedGuests = 1; // Khởi tạo số khách mặc định
  int _totalPrice = 0;

  void _updateTotalPrice(DateTime selectedCheckIn, DateTime selectedCheckOut) {
    // Nếu không có ngày chọn, trả về giá phòng cho một đêm
    if (selectedCheckIn == null || selectedCheckOut == null) {
      setState(() {
        _totalPrice = widget.Price;
      });
    } else {
      final int days = selectedCheckOut.difference(selectedCheckIn).inDays;
      setState(() {
        _checkInDate = selectedCheckIn;
        _checkOutDate = selectedCheckOut;
        _totalPrice = (days > 0 ? days : 1) * widget.Price; // Tính tổng giá
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = DateTime.now();
    if (isCheckIn && _checkInDate != null) {
      initialDate = _checkInDate!;
    } else if (!isCheckIn && _checkOutDate != null) {
      initialDate = _checkOutDate!;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = pickedDate;
          // Reset ngày trả phòng nếu không hợp lệ
          if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = pickedDate;
        }

        // Gọi callback nếu cả 2 ngày đã được chọn
        if (_checkInDate != null && _checkOutDate != null) {
          _updateTotalPrice(_checkInDate!, _checkOutDate!);
        }
      });
    }
  }

  Future<int?> _showGuestPickerDialog(BuildContext context) async {
    int tempGuests = _selectedGuests;
    return showDialog<int>(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Chọn số khách"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Số khách tối đa: ${widget.maxGuests}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: tempGuests > 1
                          ? () {
                        setState(() {
                          tempGuests--;
                        });
                      }
                          : null,
                    ),
                    Text(
                      "$tempGuests",
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: tempGuests < widget.maxGuests
                          ? () {
                        setState(() {
                          tempGuests++;
                        });
                      }
                          : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, null); // Hủy chọn
            },
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, tempGuests); // Xác nhận số khách
            },
            child: const Text("Xác nhận"),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông tin đặt phòng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _checkInDate != null
                              ? DateFormat('dd/MM/yyyy').format(_checkInDate!)
                              : "Ngày nhận phòng",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _checkOutDate != null
                              ? DateFormat('dd/MM/yyyy').format(_checkOutDate!)
                              : "Ngày trả phòng",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              // Chọn số lượng khách
              final int? pickedGuests = await _showGuestPickerDialog(context);
              if (pickedGuests != null) {
                setState(() {
                  _selectedGuests = pickedGuests;
                  _updateTotalPrice(_checkInDate ?? DateTime.now(), _checkOutDate ?? DateTime.now());
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Số khách: $_selectedGuests",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Icon(Icons.person, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _checkInDate != null && _checkOutDate != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      roomId: widget.roomId,
                      checkIn: _checkInDate!,
                      checkOut: _checkOutDate!,
                      totalPrice: _totalPrice,
                      soKhach: _selectedGuests,
                    ),
                  ),
                );
              }
                  : null,
              child: Text(
                "Đặt phòng - $_totalPrice₫",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

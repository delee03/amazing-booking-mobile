import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerSection extends StatefulWidget {
  final Function(DateTime checkIn, DateTime checkOut) onDateChanged;

  DatePickerSection({required this.onDateChanged});

  @override
  _DatePickerSectionState createState() => _DatePickerSectionState();
}

class _DatePickerSectionState extends State<DatePickerSection> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = DateTime.now();
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
        } else {
          _checkOutDate = pickedDate;
        }
        if (_checkInDate != null && _checkOutDate != null) {
          widget.onDateChanged(_checkInDate!, _checkOutDate!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chọn ngày đặt phòng",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _checkInDate != null
                          ? DateFormat('dd/MM/yyyy').format(_checkInDate!)
                          : "Ngày nhận phòng",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _checkOutDate != null
                          ? DateFormat('dd/MM/yyyy').format(_checkOutDate!)
                          : "Ngày trả phòng",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/roomdetail/room_image_slider.dart';
import '../../widgets/roomdetail/room_info_section.dart';
import '../../widgets/roomdetail/room_review_section.dart';
import '../../widgets/roomdetail/room_price_notice.dart';
import '../../widgets/roomdetail/room_comments_section.dart';
import '../../widgets/roomdetail/date_picker_section.dart';
import '../../widgets/roomdetail/book_room_button.dart';
import '../../widgets/roomdetail/room_amenities_section.dart';
import '../../widgets/roomdetail/room_description_section.dart';  // Import mô tả căn phòng

class RoomDetailScreen extends StatefulWidget {
  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  int totalPrice = 0;

  void _updateTotalPrice(DateTime checkIn, DateTime checkOut) {
    final int days = checkOut.difference(checkIn).inDays;
    setState(() {
      totalPrice = days * 200; // Giá mỗi ngày là 200 USD
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết phòng", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoomImageSlider(),
            RoomInfoSection(),
            Divider(),
            SizedBox(height: 16),
            RoomDescriptionSection(),// Hiển thị mô tả căn phòng
            SizedBox(height: 16),
            RoomAmenitiesSection(),  // Hiển thị tiện ích phòng
            RoomReviewSection(),
            Divider(),
            RoomCommentsSection(),
            Divider(),
            DatePickerSection(onDateChanged: _updateTotalPrice),
            Divider(),
            RoomPriceNotice(),
            SizedBox(height: 16),
            BookRoomButton(totalPrice: totalPrice),
          ],
        ),
      ),
    );
  }
}

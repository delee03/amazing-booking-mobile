import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/Comment.dart';
import '../../../data/models/Room.dart';
import '../../../data/services/roomdetail/RoomService.dart';
import '../../widgets/roomdetail/book_room_section.dart';
import '../../widgets/roomdetail/room_amenities_section.dart';
import '../../widgets/roomdetail/room_comments_section.dart';
import '../../widgets/roomdetail/room_description_section.dart';
import '../../widgets/roomdetail/room_image_slider.dart';
import '../../widgets/roomdetail/room_info_section.dart';
import '../../widgets/roomdetail/room_review_section.dart';

class RoomDetailScreen extends StatefulWidget {
  final String roomId;

  const RoomDetailScreen({required this.roomId});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final RoomService _roomService = RoomService();
  int totalPrice = 0;
  DateTime checkIn = DateTime.now();
  DateTime checkOut = DateTime.now().add(const Duration(days: 1));
  int selectedGuests = 1;
  late Future<List<Comment>> commentsFuture;

  @override
  void initState() {
    super.initState();
    commentsFuture = _roomService.fetchRoomComments(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chi tiết phòng",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Room>(
        future: _roomService.fetchRoomDetails(widget.roomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy thông tin phòng.'));
          }

          Room room = snapshot.data!;

          // Cập nhật totalPrice nếu chưa được tính
          if (totalPrice == 0) {
            totalPrice = room.price; // Giá mặc định là giá 1 ngày
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoomImageSlider(
                  imagesFuture: _roomService.fetchRoomImages(room.id),
                ),
                RoomInfoSection(
                  name: room.name,
                  locationId: room.locationId,
                ),
                const Divider(),
                RoomDescriptionSection(description: room.description, soKhach: room.soKhach),
                const SizedBox(height: 16),
                RoomAmenitiesSection(
                  amenities: room.tienNghi.split(',').map((e) => e.trim()).toList(),
                ),
                RoomReviewSection(
                  commentsFuture: commentsFuture,
                ),
                const Divider(),
                RoomCommentsSection(commentsFuture: commentsFuture),
                const Divider(),
                const SizedBox(height: 16),
                BookRoomSection(
                  onDateChanged: (DateTime selectedCheckIn, DateTime selectedCheckOut, int guests) {
                    setState(() {
                      this.checkIn = selectedCheckIn;
                      this.checkOut = selectedCheckOut;
                      this.selectedGuests = guests;
                    });
                  },
                  maxGuests: room.soKhach,
                  roomId: room.id,
                  soKhach: selectedGuests,
                  checkIn: checkIn,
                  checkOut: checkOut,
                  totalPrice: 0,
                  Price: room.price,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



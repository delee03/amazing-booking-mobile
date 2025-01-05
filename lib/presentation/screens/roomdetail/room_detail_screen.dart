import 'package:amazing_booking_app/data/models/Comment.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/room.dart';
import '../../../data/services/roomdetail/RoomService.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/roomdetail/book_room_section.dart';
import '../../widgets/roomdetail/room_amenities_section.dart';
import '../../widgets/roomdetail/room_comments_section.dart';
import '../../widgets/roomdetail/room_description_section.dart';
import '../../widgets/roomdetail/room_info_section.dart';
import '../../widgets/roomdetail/room_location_map.dart';
import '../../widgets/roomdetail/room_review_section.dart';

class RoomDetailScreen extends StatefulWidget {
  final String roomId;

  const RoomDetailScreen({super.key, required this.roomId});

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final RoomService _roomService = RoomService();
  int totalPrice = 0;
  DateTime checkIn = DateTime.now();
  DateTime checkOut = DateTime.now().add(const Duration(days: 1));
  int selectedGuests = 1;
  late Future<RoomDetails> _roomDetailsFuture;
  late Future<List<Comment>> _roomCommentsFuture;
  late String roomId = widget.roomId;
  @override
  void initState() {
    super.initState();
    _roomDetailsFuture = _roomService.fetchRoomDetails(widget.roomId);
    _roomCommentsFuture = _roomService.fetchRoomComments(widget.roomId);
  }

  void openMaps(double latitude, double longitude) async {
    final Uri googleMapsUri = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude");
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri);
    } else {
      throw "Could not open the map.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'Chi Tiết Phòng'),
      drawer: const AppDrawer(),
      body: FutureBuilder<RoomDetails>(
        future: _roomDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy thông tin phòng.'));
          }

          RoomDetails roomDetails = snapshot.data!;
          Room room = roomDetails.room;

          // Cập nhật totalPrice nếu chưa được tính
          if (totalPrice == 0) {
            totalPrice = room.price; // Giá mặc định là giá 1 ngày
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // RoomImageSlider(
                //   imagesFuture: Future.value(roomDetails.images),
                // ),
                RoomInfoSection(
                  name: room.name,
                  locationId: room.locationId,
                  roomId: roomId,
                ),
                const Divider(),
                RoomDescriptionSection(
                    description: room.description, soKhach: room.soKhach),
                const SizedBox(height: 16),
                RoomAmenitiesSection(
                  amenities:
                      room.tienNghi.split(',').map((e) => e.trim()).toList(),
                ),
                RoomReviewSection(
                  commentsFuture: _roomCommentsFuture,
                ),
                const Divider(),
                RoomCommentsSection(
                  commentsFuture: _roomCommentsFuture,
                ),
                const Divider(),
                const SizedBox(height: 16),
                RoomLocationMap(
                  latitude: double.parse(room.latitude),
                  longitude: double.parse(room.longitude),
                ),
                const SizedBox(height: 16),
                BookRoomSection(
                  onDateChanged: (DateTime selectedCheckIn,
                      DateTime selectedCheckOut, int guests) {
                    setState(() {
                      checkIn = selectedCheckIn;
                      checkOut = selectedCheckOut;
                      selectedGuests = guests;
                    });
                  },
                  maxGuests: room.soKhach,
                  roomId: room.id,
                  soKhach: selectedGuests,
                  checkIn: checkIn,
                  checkOut: checkOut,
                  totalPrice: totalPrice,
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

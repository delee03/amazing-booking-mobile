import 'package:flutter/material.dart';
import '../../../data/models/Location.dart';
import '../../../data/services/roomdetail/RoomService.dart';

class RoomInfoSection extends StatefulWidget {
  final String name;
  final String locationId;
  final String roomId;

  const RoomInfoSection({
    super.key,
    required this.name,
    required this.locationId,
    required this.roomId, // Tham số bắt buộc
  });

  @override
  _RoomInfoSectionState createState() => _RoomInfoSectionState();
}

class _RoomInfoSectionState extends State<RoomInfoSection> {
  late Future<RoomDetails> _roomDetailsFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API để lấy thông tin chi tiết phòng bao gồm vị trí, bình luận và ảnh
    _roomDetailsFuture = RoomService().fetchRoomDetails(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Hiển thị thông tin về địa chỉ
          FutureBuilder<RoomDetails>(
            future: _roomDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Lỗi khi tải địa chỉ: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('Không có thông tin về địa chỉ.');
              }
              final location = snapshot.data!.room.location.city;
              final address = snapshot.data!.room.address;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location, // Hiển thị địa chỉ đầy đủ
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          overflow: TextOverflow
                              .ellipsis, // Giới hạn địa chỉ trong một dòng với dấu ba chấm nếu quá dài
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address, // Thay đoạn văn bản bằng địa chỉ
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

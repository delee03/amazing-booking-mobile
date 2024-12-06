import 'package:flutter/material.dart';
import '../../../data/models/Location.dart';
import '../../../data/services/roomdetail/RoomService.dart';

class RoomInfoSection extends StatefulWidget {
  final String name;
  final String locationId; // locationId là tham số bắt buộc

  RoomInfoSection({
    required this.name,
    required this.locationId, // Tham số bắt buộc
  });

  @override
  _RoomInfoSectionState createState() => _RoomInfoSectionState();
}

class _RoomInfoSectionState extends State<RoomInfoSection> {
  late Future<Location> _locationFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API để lấy thông tin Location
    _locationFuture = RoomService().fetchLocationById(widget.locationId);
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          // Hiển thị thông tin về location
          FutureBuilder<Location>(
            future: _locationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Lỗi khi tải vị trí: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('Không có thông tin về vị trí.');
              }

              final location = snapshot.data!;
              return Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    "Vị trí: ${location.getFullLocation()}.", // Hiển thị tên vị trí đầy đủ
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 8),
          Text(
            "Thông tin chi tiết về phòng",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

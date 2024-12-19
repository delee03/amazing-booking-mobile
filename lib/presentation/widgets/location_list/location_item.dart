import 'package:flutter/material.dart';

class LocationItem extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String id;

  const LocationItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.id,
  });

  @override
  _LocationItemState createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.white10, // Màu mặc định
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.asset(
              widget.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0, // Kích thước cố định
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left, // Căn trái tên địa điểm
            ),
          ),
        ],
      ),
    );
  }
}

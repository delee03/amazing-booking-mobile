import 'package:flutter/material.dart';

class LocationSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const LocationSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: const Color(0xFFEF4444),
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

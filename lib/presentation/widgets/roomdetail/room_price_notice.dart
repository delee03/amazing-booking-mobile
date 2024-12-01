import 'package:flutter/material.dart';

class RoomPriceNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.pink, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_offer, color: Colors.pink, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Giá thấp hơn: Những ngày bạn chọn có giá thấp hơn 164 SGD so với mức giá trung bình theo đêm trong 60 ngày qua.",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

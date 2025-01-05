import 'package:amazing_booking_app/presentation/widgets/profile/booking_status.dart';
import 'package:flutter/material.dart';
import 'booking_status_helper.dart';

class BookingDetailWidgets {
  static Widget buildInfoRow(String label, String value,
      {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: valueStyle ?? TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildStatusBadge(BookingStatus status) {
    final statusText = BookingStatusHelper.getStatusText(status);
    final statusColor = BookingStatusHelper.getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  static Widget buildActionButtons(
    BuildContext context, {
    required VoidCallback onDelete,
    required VoidCallback onEdit,
    bool isUnpaid = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (isUnpaid) ...[
          Expanded(
            child: ElevatedButton(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.orange,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.orange),
              ),
              child: Text("Chỉnh sửa"),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onDelete,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.red),
              ),
              child: Text("Xóa đặt phòng"),
            ),
          ),
        ],
      ],
    );
  }
}

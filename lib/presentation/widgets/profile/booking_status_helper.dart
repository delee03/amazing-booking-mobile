import 'package:flutter/material.dart';
import 'booking_status.dart';

class BookingStatusHelper {
  static BookingStatus getBookingStatus(DateTime? checkIn, DateTime? checkOut, bool paymentStatus) {
    try {
      final now = DateTime.now();

      if (checkIn == null || checkOut == null) {
        return BookingStatus.unknown;
      }

      if (checkOut.isBefore(now)) {
        return BookingStatus.expired;
      }

      if (!paymentStatus) {
        return BookingStatus.unpaid;
      }

      if (now.isBefore(checkIn)) {
        return BookingStatus.upcoming;
      }

      if (now.isAfter(checkIn) && now.isBefore(checkOut)) {
        return BookingStatus.ongoing;
      }

      return BookingStatus.completed;

    } catch (e) {
      debugPrint('Error getting booking status: $e');
      return BookingStatus.unknown;
    }
  }

  static String getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.expired:
        return "Đã hết hạn";
      case BookingStatus.unpaid:
        return "Chưa thanh toán";
      case BookingStatus.upcoming:
        return "Sắp tới";
      case BookingStatus.ongoing:
        return "Đang diễn ra";
      case BookingStatus.completed:
        return "Đã hoàn thành";
      case BookingStatus.unknown:
        return "Không xác định";
    }
  }

  static Color getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.expired:
        return Colors.red;
      case BookingStatus.unpaid:
        return Colors.orange;
      case BookingStatus.upcoming:
        return Colors.blue;
      case BookingStatus.ongoing:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.grey;
      case BookingStatus.unknown:
        return Colors.grey;
    }
  }
}
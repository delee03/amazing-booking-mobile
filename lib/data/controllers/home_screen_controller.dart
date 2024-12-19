import 'dart:math';

import 'package:amazing_booking_app/data/services/home_screen_service.dart';

import '../models/hotel.dart';

class HomeScreenController {
  final HomeScreenService _service = HomeScreenService();

  final List<String> imageNames = [
    '1.jpg', '2.jpg', '3.jpg', '4.jpg', '5.jpg',
    '6.jpg', '7.jpg', '8.jpg', '9.jpg'
  ];

  List<String> getRandomImages(int count) {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final shuffledImages = List<String>.from(imageNames)..shuffle(random);
    return shuffledImages.take(count).toList();
  }

  Future<List<String>> fetchLocationNames() async {
    return await _service.fetchLocationNames();
  }

  Future<List<Hotel>> fetchTopHotels() async {
    return await _service.fetchTopHotels();
  }

  Future<List<dynamic>> fetchTopLocations() async {
    return await _service.fetchTopLocations();
  }

  DateTime? parseDateTime(String? dateString) {
    return dateString != null ? DateTime.tryParse(dateString) : null;
  }
}
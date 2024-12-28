import 'package:flutter/material.dart';
import '../../../data/models/hotel.dart';
import 'hotel_card.dart';

class HotelCardList extends StatelessWidget {
  final List<Hotel> hotels;

  const HotelCardList({
    super.key,
    required this.hotels,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        return HotelCard(hotel: hotels[index]);
      },
    );
  }
}
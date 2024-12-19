import 'package:flutter/material.dart';
import '../../screens/discover_rooms/discover_rooms_screen.dart';

class TopLocationSection extends StatelessWidget {
  final List<dynamic> locations;
  final List<String> randomImages;

  const TopLocationSection({
    Key? key,
    required this.locations,
    required this.randomImages
  }) : super(key: key);

  void handleLocationTap(BuildContext context, String locationId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DiscoverRoomsScreen(
                selectedLocationName: locationId
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildLocationCard(context, 0),
                  const SizedBox(height: 16),
                  _buildLocationCard(context, 1),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLocationCard(context, 2, height: 216),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFullWidthLocationCard(context, 3),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildLocationCard(context, 4, height: 150),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLocationCard(context, 5, height: 150),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationCard(BuildContext context, int index, {double height = 100}) {
    return GestureDetector(
      onTap: () => handleLocationTap(context, locations[index]['id']),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/top_location/${randomImages[index]}',
              width: MediaQuery.of(context).size.width / 2 - 24,
              height: height,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locations[index]['country'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    locations[index]['city'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthLocationCard(BuildContext context, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () => handleLocationTap(context, locations[index]['id']),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/top_location/${randomImages[index]}',
              width: MediaQuery.of(context).size.width - 32,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locations[index]['country'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    locations[index]['city'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
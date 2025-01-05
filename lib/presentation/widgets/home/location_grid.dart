import 'package:flutter/material.dart';

class LocationGrid extends StatelessWidget {
  final List<dynamic> locations;
  final List<String> images;
  final Function(String) onLocationTap;

  const LocationGrid({
    Key? key,
    required this.locations,
    required this.images,
    required this.onLocationTap,
  }) : super(key: key);

  Widget _buildLocationCard({
    required String image,
    required dynamic locationData,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    // Safely access location data
    final country = locationData is Map ? locationData['country']?.toString() ?? '' : '';
    final city = locationData is Map ? locationData['city']?.toString() ?? '' : '';

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/top_location/$image',
              width: width,
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
                    country,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    city,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2;

    // Safe check for minimum locations
    if (locations.length < 6 || images.length < 6) {
      return const SizedBox(); // Or some error widget
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildLocationCard(
                      image: images[0],
                      locationData: locations[0],
                      width: cardWidth,
                      height: 100,
                      onTap: () => onLocationTap(
                          locations[0] is Map ? locations[0]['city']?.toString() ?? '' : ''
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLocationCard(
                      image: images[1],
                      locationData: locations[1],
                      width: cardWidth,
                      height: 100,
                      onTap: () => onLocationTap(
                          locations[1] is Map ? locations[1]['city']?.toString() ?? '' : ''
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLocationCard(
                  image: images[2],
                  locationData: locations[2],
                  width: cardWidth,
                  height: 216,
                  onTap: () => onLocationTap(
                      locations[2] is Map ? locations[2]['city']?.toString() ?? '' : ''
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLocationCard(
            image: images[3],
            locationData: locations[3],
            width: screenWidth - 32,
            height: 200,
            onTap: () => onLocationTap(
                locations[3] is Map ? locations[3]['city']?.toString() ?? '' : ''
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildLocationCard(
                  image: images[4],
                  locationData: locations[4],
                  width: cardWidth,
                  height: 150,
                  onTap: () => onLocationTap(
                      locations[4] is Map ? locations[4]['city']?.toString() ?? '' : ''
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLocationCard(
                  image: images[5],
                  locationData: locations[5],
                  width: cardWidth,
                  height: 150,
                  onTap: () => onLocationTap(
                      locations[5] is Map ? locations[5]['city']?.toString() ?? '' : ''
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
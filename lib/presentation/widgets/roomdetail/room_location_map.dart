import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RoomLocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  RoomLocationMap({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latitude, longitude),
                width: 80.0,
                height: 80.0,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

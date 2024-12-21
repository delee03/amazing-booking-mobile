import 'dart:async';
import 'dart:convert';
import 'dart:math' show atan2, cos, log, max, min, pi, sin, sqrt;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class RouteMapScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;

  const RouteMapScreen({
    Key? key,
    required this.destinationLat,
    required this.destinationLng,
  }) : super(key: key);

  @override
  _RouteMapScreenState createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  final Location _locationService = Location();
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  List<LatLng> _routePoints = [];
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<LocationData>? _locationSubscription;

  // OpenRouteService API key
  static const String _openRouteServiceKey =
      '5b3ce3597851110001cf62483bdc9542510f4f1e942ab30df4edfdaf'; // Thay bằng key của bạn

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          setState(() => _errorMessage = 'Vui lòng bật dịch vụ vị trí');
          return;
        }
      }

      PermissionStatus permissionGranted =
      await _locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() => _errorMessage = 'Cần quyền truy cập vị trí');
          return;
        }
      }

      _currentLocation = await _locationService.getLocation();
      if (_currentLocation != null) {
        _startLocationUpdates();
        await _fetchRoute();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể lấy vị trí: $e';
      });
    }
  }

  void _startLocationUpdates() {
    _locationSubscription = _locationService.onLocationChanged.listen(
          (LocationData newLocation) async {
        if (_currentLocation != null) {
          double distance = _calculateDistance(
            _currentLocation!.latitude!,
            _currentLocation!.longitude!,
            newLocation.latitude!,
            newLocation.longitude!,
          );

          if (distance > 10) {
            // Cập nhật khi di chuyển hơn 10m
            setState(() => _currentLocation = newLocation);
            await _fetchRoute();
          }
        } else {
          setState(() => _currentLocation = newLocation);
          await _fetchRoute();
        }
      },
    );
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null) return;

    try {
      final response = await http.post(
        Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car/geojson'),
        headers: {
          'Authorization': _openRouteServiceKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'coordinates': [
            [_currentLocation!.longitude, _currentLocation!.latitude],
            [widget.destinationLng, widget.destinationLat]
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'] != null &&
            data['features'].isNotEmpty &&
            data['features'][0]['geometry'] != null &&
            data['features'][0]['geometry']['coordinates'] != null) {

          final coordinates = data['features'][0]['geometry']['coordinates'] as List;

          setState(() {
            _routePoints = coordinates.map((coord) {
              if (coord is List && coord.length >= 2) {
                return LatLng(coord[1].toDouble(), coord[0].toDouble());
              }
              return null;
            }).whereType<LatLng>().toList();
          });

          if (_routePoints.isNotEmpty) {
            _fitBounds();
          } else {
            setState(() => _errorMessage = 'Không tìm thấy đường đi');
          }
        } else {
          setState(() => _errorMessage = 'Dữ liệu tuyến đường không hợp lệ');
        }
      } else {
        setState(() => _errorMessage = 'Không thể tải đường đi (${response.statusCode})');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Lỗi kết nối: $e');
    }
  }

  void _fitBounds() {
    if (_routePoints.isEmpty) return;

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var point in _routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Add current location and destination to bounds calculation
    if (_currentLocation != null) {
      minLat = min(minLat, _currentLocation!.latitude!);
      maxLat = max(maxLat, _currentLocation!.latitude!);
      minLng = min(minLng, _currentLocation!.longitude!);
      maxLng = max(maxLng, _currentLocation!.longitude!);
    }

    minLat = min(minLat, widget.destinationLat);
    maxLat = max(maxLat, widget.destinationLat);
    minLng = min(minLng, widget.destinationLng);
    maxLng = max(maxLng, widget.destinationLng);

    // Calculate center point
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    // Calculate appropriate zoom level
    final latZoom = log(360 / (maxLat - minLat)) / log(2);
    final lngZoom = log(360 / (maxLng - minLng)) / log(2);
    final zoom = min(latZoom, lngZoom) - 1; // Subtract 1 to add some padding

    _mapController?.moveCamera(
      CameraUpdate.newLatLngZoom(LatLng(centerLat, centerLng), zoom),
    );
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3;
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉ đường'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRoute,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation != null
                  ? LatLng(
                  _currentLocation!.latitude!, _currentLocation!.longitude!)
                  : LatLng(widget.destinationLat, widget.destinationLng),
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: {
              if (_currentLocation != null)
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: LatLng(
                    _currentLocation!.latitude!,
                    _currentLocation!.longitude!,
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ),
              Marker(
                markerId: MarkerId('destination'),
                position: LatLng(widget.destinationLat, widget.destinationLng),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
            polylines: {
              if (_routePoints.isNotEmpty)
                Polyline(
                  polylineId: PolylineId('route'),
                  points: _routePoints,
                  color: Colors.blue,
                  width: 5,
                ),
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (_errorMessage != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

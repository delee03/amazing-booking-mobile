import 'dart:math';

import 'package:flutter/material.dart';

import '../../../data/services/api_client.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/location_list/location_item.dart';
import '../../widgets/location_list/search_bar.dart';
import '../discover_rooms/discover_rooms_screen.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  _LocationListScreenState createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  int _selectedIndex = 2;
  List<Map<String, String>> _locations = [];
  String _searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args.containsKey('selectedIndex')) {
      _selectedIndex = args['selectedIndex'];
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() async {
    try {
      final locations = await ApiClient().fetchLocations();
      setState(() {
        _locations = locations
            .map((location) {
              final random = Random();
              final imageUrl =
                  'assets/images/top_location/${random.nextInt(9) + 1}.jpg';
              return {
                "imageUrl": imageUrl,
                "name": location['city'].toString(),
                "id": location['id'].toString(),
              };
            })
            .toList()
            .cast<Map<String, String>>();
      });
    } catch (e) {
      // Xử lý lỗi nếu cần
    }
  }

  void _navigateToDiscoverRooms(BuildContext context, String location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DiscoverRoomsScreen(selectedLocationName: location),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String removeDiacritics(String str) {
    const vietnamese =
        'ạáảãàâậấẩẫầăặắẳẵằèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ';
    const nonVietnamese =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

    for (int i = 0; i < vietnamese.length; i++) {
      str = str.replaceAll(vietnamese[i], nonVietnamese[i]);
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    final filteredLocations = _locations.where((location) {
      final nameLower = removeDiacritics(location['name']!.toLowerCase());
      final searchLower = removeDiacritics(_searchQuery.toLowerCase());
      return nameLower.contains(searchLower);
    }).toList();

    return Scaffold(
      appBar: buildAppBar(context, title: 'Địa Điểm'),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Địa điểm',
                style: TextStyle(
                  fontSize: 40, // Kích thước chữ lớn
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 50),
            LocationSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 30),
            ...filteredLocations
                .map((location) => GestureDetector(
                      onTap: () =>
                          _navigateToDiscoverRooms(context, location['name']!),
                      child: LocationItem(
                        imageUrl: location["imageUrl"]!,
                        name: location["name"]!,
                        id: location["id"]!,
                      ),
                    ))
                ,
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

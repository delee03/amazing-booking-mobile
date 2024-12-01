
import 'package:amazing_booking_app/presentation/screens/home/home_screen.dart';
import 'package:amazing_booking_app/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  //Danh sách các màn hình
  final List<Widget> _screens = [
    const Center(child: Text('Khám phá', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Yêu thích', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Chuyến đi', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Tin nhắn', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Hồ sơ', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

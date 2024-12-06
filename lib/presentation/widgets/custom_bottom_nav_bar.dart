import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);

        // Điều hướng đến màn hình chỉ khi người dùng chưa ở trang này
        if (index == 0 && selectedIndex != 0) {
          Navigator.pushReplacementNamed(context, '/discover',
              arguments: {'selectedIndex': index});
        } else if (index == 1 && selectedIndex != 1) {
          Navigator.pushReplacementNamed(context, '/favorites',
              arguments: {'selectedIndex': index});
        } else if (index == 2 && selectedIndex != 2) {
          Navigator.pushReplacementNamed(context, '/location',
              arguments: {'selectedIndex': index});
        } else if (index == 3 && selectedIndex != 3) {
          Navigator.pushReplacementNamed(context, '/messages',
              arguments: {'selectedIndex': index});
        } else if (index == 4 && selectedIndex != 4) {
          Navigator.pushReplacementNamed(context, '/profile',
              arguments: {'selectedIndex': index});
        }
      },
      selectedItemColor: const Color(0xFFEF4444),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Khám phá',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Địa điểm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Tin nhắn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}

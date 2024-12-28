import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final VoidCallback onTap; // Hàm xử lý khi bấm nút
  final String label;
  final IconData icon;

  const SearchButton({
    super.key,
    required this.onTap,
    this.label = 'Tìm kiếm',
    this.icon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: GestureDetector(
        onTap: () {
          onTap();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đang tìm kiếm...'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

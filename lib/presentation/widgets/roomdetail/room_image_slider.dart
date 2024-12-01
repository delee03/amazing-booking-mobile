import 'package:flutter/material.dart';

class RoomImageSlider extends StatefulWidget {
  @override
  _RoomImageSliderState createState() => _RoomImageSliderState();
}

class _RoomImageSliderState extends State<RoomImageSlider> {
  final List<String> imageUrls = [
    'https://via.placeholder.com/600x400/0000FF',
    'https://via.placeholder.com/600x400/FF0000',
    'https://via.placeholder.com/600x400/00FF00',
    'https://via.placeholder.com/600x400/FFFF00',
  ];

  // Để theo dõi vị trí hình ảnh hiện tại
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hình ảnh với PageView
        Container(
          height: 400, // Chiều cao cho hình ảnh
          child: PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrls[index], // Lấy URL hình ảnh
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),

        // Nút điều hướng
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, size: 30),
                onPressed: () {
                  if (_pageController.hasClients) {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, size: 30),
                onPressed: () {
                  if (_pageController.hasClients) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

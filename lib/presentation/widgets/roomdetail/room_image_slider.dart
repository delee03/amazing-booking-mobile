import 'package:flutter/material.dart';

class RoomImageSlider extends StatefulWidget {
  final Future<List<String>> imagesFuture;

  const RoomImageSlider({super.key, required this.imagesFuture});

  @override
  _RoomImageSliderState createState() => _RoomImageSliderState();
}

class _RoomImageSliderState extends State<RoomImageSlider> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.imagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Không có hình ảnh để hiển thị.', style: TextStyle(fontSize: 16)),
          );
        }

        final images = snapshot.data!;

        return Column(
          children: [
            // Hình ảnh dạng slider
            SizedBox(
              height: 300, // Thay đổi chiều cao ảnh ở đây
              child: images.isNotEmpty
                  ? PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      images[index],
                      width: double.infinity,
                      height: 200, // Đảm bảo chiều cao của ảnh khớp với Container
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                },
              )
                  : const Center(
                child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            ),
            // Chỉ báo vị trí slider
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pageController.hasClients &&
                          _pageController.page?.round() == index
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

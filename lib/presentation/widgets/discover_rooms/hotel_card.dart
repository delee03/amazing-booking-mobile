import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class HotelCard extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String name;
  final String location;
  final String description;
  final double rating; // Số sao
  final int bookings; // Số lượt đặt
  final String roomStatus; // Trạng thái tòa nhà (Còn chỗ hoặc Hết chỗ)

  const HotelCard({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.name,
    required this.location,
    required this.description,
    required this.rating,
    required this.bookings,
    required this.roomStatus,
  });

  String formatPrice(String price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị hình ảnh từ URL
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
              const SizedBox(height: 10),
              // Hiển thị giá phòng
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  formatPrice(price),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Hiển thị tên phòng và số sao
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFF1F1D63),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        Text(
                          rating > 0
                              ? rating.toStringAsFixed(1)
                              : 'Chưa có đánh giá',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // Hiển thị địa điểm và trạng thái phòng
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Hiển thị trạng thái phòng với màu sắc tương ứng
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: roomStatus == 'Còn phòng'
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        roomStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // Hiển thị mô tả phòng
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

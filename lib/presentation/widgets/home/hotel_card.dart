import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/hotel.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    var formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    String formattedPrice = '${formatCurrency.format(hotel.price)} /ngày';

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
      child: Container(
        width: double.infinity, // Đặt chiều rộng cho container
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
              SizedBox(
                width: double.infinity, // Đặt chiều rộng cho hình ảnh
                height: 200, // Đặt chiều cao cho hình ảnh
                child: Image.network(
                  hotel.avatar,
                  fit: BoxFit
                      .cover, // Chỉnh kích thước hình ảnh để phủ đầy khung
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedPrice,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 5),
                        Text(
                          hotel.averageStar.toStringAsFixed(
                              1), // Hiển thị số sao trung bình với 1 chữ số thập phân
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF1F1D63),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  hotel.name,
                  style: const TextStyle(
                    color: Color(0xFF1F1D63),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      hotel.locationName, // Hiển thị tên địa điểm
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    18.0, 0, 18.0, 16.0), // Mở rộng padding cho mô tả
                child: Text(
                  hotel.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

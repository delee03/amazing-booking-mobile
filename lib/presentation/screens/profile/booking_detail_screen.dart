
import 'package:amazing_booking_app/presentation/screens/profile/room_review_screen.dart';
import 'package:flutter/material.dart';
import '../roomdetail/room_detail_screen.dart'; // Import the RoomDetailScreen

class BookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails = {
    "imageUrl": "https://via.placeholder.com/150", // Example image URL
    "roomName": "Luxury Room with Eiffel View", // Room name
    "bookingDate": "01/12/2024", // Booking date
    "expiryDate": "01/01/2025", // Expiry date
    "totalPrice": 150, // Total price
    "paymentMethod": "Credit Card", // Payment method
  };

  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Trần Thị B",
      "comment":
      "Chủ nhà thân thiện và nhiệt tình. Sẽ quay lại lần nữa! Mọi thứ đều tuyệt vời. Phòng rất đẹp, view tháp Eiffel tuyệt vời! Phòng rất sạch sẽ và đầy đủ tiện nghi, tôi rất hài lòng với dịch vụ tại đây.",
      "rating": 4,
      "date": "20/11/2024"
    },
    // You can add more reviews here if needed
  ];

  // // Navigate to the RoomDetailScreen when the user wants to view room details
  // void _navigateToRoomDetailScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => RoomDetailScreen()),
  //   );
  // }

  // Navigate to the RoomReviewScreen when the user wants to add a review
  void _navigateToReviewScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoomReviewScreen()),
    );
  }

  // Method to display rating as stars
  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border_outlined,
          color: Color(0xFFEF4444), // Red color for stars
          size: 24,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image and Details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  bookingDetails['imageUrl'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookingDetails['roomName'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Ngày đặt: ${bookingDetails['bookingDate']}'),
                      Text('Ngày hết hạn: ${bookingDetails['expiryDate']}'),
                      Text('Thành tiền: ${bookingDetails['totalPrice']} VND'),
                      Text('Hình thức thanh toán: ${bookingDetails['paymentMethod']}'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Row for both buttons (Thông tin phòng and Đánh giá phòng)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // "Thông tin phòng" button
                // ElevatedButton(
                //   onPressed: () => _navigateToRoomDetailScreen(context),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Color(0xFFEF4444), // Set button background color
                //   ),
                //   child: Text(
                //     'Thông tin phòng',
                //     style: TextStyle(color: Colors.white), // White text
                //   ),
                // ),
                SizedBox(width: 16), // Space between the buttons
                // "Đánh giá phòng" button
                ElevatedButton(
                  onPressed: () => _navigateToReviewScreen(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF4444), // Set button background color
                  ),
                  child: Text(
                    'Đánh giá phòng',
                    style: TextStyle(color: Colors.white), // White text
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Text(
              'Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(review['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review['comment']),
                          SizedBox(height: 5),
                          // Display rating as stars
                          _buildRatingStars(review['rating']),
                          SizedBox(height: 5),
                          Text('Date: ${review['date']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

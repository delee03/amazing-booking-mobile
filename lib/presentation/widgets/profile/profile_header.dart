import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final Color textColor;

  ProfileHeader({required this.imageUrl, required this.userName, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(imageUrl),
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }
}

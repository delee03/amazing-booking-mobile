import 'package:flutter/material.dart';

class UserDetailsDialog extends StatelessWidget {
  final String avata;
  final String userName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  const UserDetailsDialog({
    super.key,
    required this.avata,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Thông tin người dùng", style: TextStyle(color: Color(0xFFEF4444))),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const SizedBox(height: 16),
            Text("Tên người dùng: $userName", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Email: $email", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Số điện thoại: $phoneNumber", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Địa chỉ: $address", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text("Mật khẩu: ********", style: TextStyle(fontSize: 18)), // Mask password for security
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Đóng", style: TextStyle(color: Color(0xFFEF4444))),
        ),
      ],
    );
  }
}

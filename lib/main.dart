
import 'package:amazing_booking_app/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Profile',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProfileScreen(),
    );
  }
}

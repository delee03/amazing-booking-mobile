import 'package:amazing_booking_app/presentation/screens/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    if (kDebugMode) {
      print("Environment file loaded successfully!");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error loading .env file: $e");
    }
  }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
        return  const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
  }
}

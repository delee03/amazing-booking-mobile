import 'package:amazing_booking_app/presentation/screens/home/home_screen.dart';
import 'package:amazing_booking_app/presentation/screens/login/login-page.dart';
import 'package:amazing_booking_app/presentation/screens/profile/profile_screen.dart';
import 'package:amazing_booking_app/presentation/screens/roomdetail/room_detail_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print("Environment file loaded successfully!");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  print("Env variables: ${dotenv.env}");
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:LoginScreen(),
      //RoomDetailScreen (roomId: "671293b2111d754e66fc1f52",),
      //HomeScreen(),
      routes: {
        '/profile': (context) => ProfileScreen()
      },
    );
  }
}

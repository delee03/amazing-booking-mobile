import 'package:amazing_booking_app/presentation/screens/discover_rooms/discover_rooms_screen.dart';
import 'package:amazing_booking_app/presentation/screens/home/home_screen.dart';
import 'package:amazing_booking_app/presentation/screens/location_list/location_list_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print("Environment file loaded successfully!");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(), // Màn hình chính
      routes: {
        '/discover': (context) =>
            const DiscoverRoomsScreen(), // Màn hình khám phá
        '/location': (context) => LocationListScreen(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('vi', 'VN'), // Vietnamese
      ],
    );
  }
}

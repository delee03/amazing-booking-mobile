import 'package:amazing_booking_app/data/services/auth.service.dart';
import 'package:amazing_booking_app/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();


}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;
  Color _emailIconColor = Colors.black54;
  Color _passwordIconColor = Colors.black54;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {

      _isLoading = true;
    });

    try {
      final response = await _authService.login(email, password);
      print("Response Data: ${response.data}");

      final statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        final token = response.data['token'];
        final user = response.data['content']['user'];

        if (token != null && user != null) {
          Fluttertoast.showToast(msg: "Login successful!");
          print("User: ${user['name']}");
          print("Token: $token");

        //  Navigate to home screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Fluttertoast.showToast(msg: "Login failed: Invalid server response.");
        }
      } else {
        final errorMessage = response.data['message'] ?? "Login failed: Unexpected error.";
        Fluttertoast.showToast(msg: errorMessage);
      }
    } catch (e) {
      print("Error during login: $e");
      Fluttertoast.showToast(msg: "Login failed: Unable to connect.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to focus nodes
    _emailFocusNode.addListener(() {
      setState(() {
        _emailIconColor =
        _emailFocusNode.hasFocus ? const Color(0xFFEF4444) : Colors.black54;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _passwordIconColor =
        _passwordFocusNode.hasFocus ? const Color(0xFFEF4444) : Colors.black54;
      });
    });
  }

  @override
  void dispose() {
    // Dispose focus nodes to prevent memory leaks
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo
              const SizedBox(height: 40),
              SvgPicture.asset(
                'assets/images/auth/airbnb.svg',
                height: size.height * 0.07,
              ),
              const SizedBox(height: 20),

              // Welcome Text
              const Text(
                'Amazing Booking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Vui lòng đăng nhập',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // Email Text Field
              TextFormField(
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: _emailIconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFEF4444)),
                  ),
                  floatingLabelStyle: const TextStyle(color: Color(0xFFEF4444)),
                ),
              ),
              const SizedBox(height: 20),

              // Password Text Field
              TextFormField(
                focusNode: _passwordFocusNode,
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock, color: _passwordIconColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFEF4444)),
                  ),
                  floatingLabelStyle: const TextStyle(color: Color(0xFFEF4444)),
                ),
              ),
              const SizedBox(height: 20),

              // Forgot Password Text Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Handle Forgot Password
                  },
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () => _login(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.8, 50),
                  backgroundColor: const Color(0xFFEF4444),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),

              // Divider with text
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey[400]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('hoặc'),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey[400]),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0.5),
                      onPressed: () {
                        // Handle Google Login
                      },
                      icon: const Icon(Icons.g_mobiledata_rounded),
                      iconSize: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // Handle Facebook Login
                    },
                    icon: const Icon(Icons.facebook),
                    iconSize: 50,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Signup Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản?'),
                  TextButton(
                    onPressed: () {
                      // Handle Signup Navigation
                    },
                    child: const Text(
                      'Đăng kí',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

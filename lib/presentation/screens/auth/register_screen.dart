import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../data/services/auth_service.dart';
import 'package:intl/intl.dart';  // For formatting DateTime to String

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime _selectedBirthday = DateTime.now();
  bool _isMale = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  /// Mở DatePicker để chọn ngày sinh
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  /// Kiểm tra định dạng email và các giá trị đầu vào
  bool _validateInputs() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please fill in all fields!");
      return false;
    }
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      Fluttertoast.showToast(msg: "Invalid email format!");
      return false;
    }
    if (_passwordController.text.trim().length < 6) {
      Fluttertoast.showToast(
          msg: "Password must be at least 6 characters long!");
      return false;
    }
    return true;
  }

  /// Đăng ký người dùng
  Future<void> _register(BuildContext context) async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final phone = _phoneController.text.trim();
      final birthday = _selectedBirthday;
      final gender = _isMale;
      final role = "USER";  // Điều chỉnh role thành USER
      final avatar = "https://example.com/default-avatar.png";  // Đặt avatar là đường dẫn đến file ảnh

      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        avatar: avatar,
        birthday: birthday,
        gender: gender,
        role: role,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Registration successful!");
        Navigator.pop(context);
      } else {
        final errorMessage =
            response.data['message'] ?? "Unknown error occurred.";
        Fluttertoast.showToast(msg: "Registration failed: $errorMessage");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Tạo TextField với các tham số
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      readOnly: onTap != null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF4444),
        title: const Text('Register'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create an Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      controller: _nameController, label: "Name", icon: Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: "Phone Number",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(_selectedBirthday),
                        ),
                        label: "Birthday",
                        icon: Icons.cake,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text("Gender:"),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Male"),
                        selected: _isMale,
                        onSelected: (selected) {
                          setState(() {
                            _isMale = true;
                          });
                        },
                        selectedColor: const Color(0xFFEF4444),
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Female"),
                        selected: !_isMale,
                        onSelected: (selected) {
                          setState(() {
                            _isMale = false;
                          });
                        },
                        selectedColor: const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _register(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Color(0xFFEF4444)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

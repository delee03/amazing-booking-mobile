import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/user_storage.dart';
import '../../../data/services/UserService.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  // Biến dữ liệu
  File? _image; // Ảnh đại diện người dùng
  String? userId; // ID người dùng
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate; // Ngày sinh
  bool _isMale = true; // Giới tính mặc định

  // Lấy thông tin người dùng khi khởi tạo màn hình
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await UserStorage.getUserData();
    if (userData != null) {
      setState(() {
        userId = userData['id']; // ID người dùng
        _nameController.text = userData['name'] ?? "";
        _emailController.text = userData['email'] ?? "";
        _phoneController.text = userData['phone'] ?? "";
        _selectedDate = userData['birthday'] != null
            ? DateTime.parse(userData['birthday'])
            : null;
        _isMale = userData['gender'] ?? true;
      });
    }
  }

  // Phương thức chọn ảnh
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Phương thức chọn ngày sinh
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Phương thức lưu thông tin cập nhật
  Future<void> _saveChanges() async {
    if (userId == null) return; // Nếu không có ID người dùng thì không xử lý

    // Lấy thông tin người dùng từ UserStorage
    final userData = await UserStorage.getUserData();
    if (userData == null) return; // Trả về nếu không có dữ liệu người dùng

    // Sử dụng giá trị từ controller nếu có, nếu không sẽ lấy từ UserStorage
    String name = _nameController.text.isNotEmpty ? _nameController.text : userData['name'] ?? '';
    String email = _emailController.text.isNotEmpty ? _emailController.text : userData['email'] ?? '';
    String phone = _phoneController.text.isNotEmpty ? _phoneController.text : userData['phone'] ?? '';
    String birthday = _selectedDate?.toIso8601String() ?? userData['birthday'] ?? '';
    bool gender = _isMale;

    try {
      await _userService.updateUser(
        userId!,
        name: name,
        email: email,
        phone: phone,
        birthday: birthday,
        gender: gender,
        password: "", // Giữ nguyên mật khẩu
        avatar: _image != null ? _image!.path : "", // Lưu path ảnh
        role: "", // Giữ nguyên role
      );

      // Cập nhật dữ liệu trong SharedPreferences
      await UserStorage.saveUserData({
        'id': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'birthday': birthday,
        'gender': gender,
      }, await UserStorage.getUserToken() ?? "");

      // Thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thông tin đã được cập nhật thành công!')),
      );

      Navigator.pop(context); // Quay lại trang trước
    } catch (e) {
      // Thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thất bại: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa hồ sơ", style: TextStyle(color: Color(0xFFEF4444))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFEF4444)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Ảnh đại diện
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image == null
                    ? NetworkImage("assets/images/avata.png") // Ảnh mặc định
                    : FileImage(_image!) as ImageProvider,
              ),
            ),
            SizedBox(height: 16),

            // Tên người dùng
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Tên người dùng",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),

            // Số điện thoại
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),

            // Ngày sinh
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Ngày sinh",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? "Chưa chọn"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Giới tính
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Giới tính:", style: TextStyle(fontSize: 16)),
                SizedBox(width: 20),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: _isMale,
                      onChanged: (value) {
                        setState(() {
                          _isMale = value!;
                        });
                      },
                    ),
                    Text("Nam"),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: false,
                      groupValue: _isMale,
                      onChanged: (value) {
                        setState(() {
                          _isMale = value!;
                        });
                      },
                    ),
                    Text("Nữ"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),

            // Nút lưu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444),
                foregroundColor: Colors.white,
              ),
              onPressed: _saveChanges,
              child: Text("Lưu thay đổi"),
            ),
          ],
        ),
      ),
    );
  }
}

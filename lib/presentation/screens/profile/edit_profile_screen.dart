import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/user_storage.dart';
import '../../../data/services/UserService.dart';
import '../../../data/services/api_client.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  File? _image; // Ảnh đại diện người dùng (nếu chọn mới)
  String? _avatarUrl; // URL ảnh đại diện từ dữ liệu người dùng
  String? userId; // ID người dùng
  String? token; // Token để xác thực
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedDateString; // Ngày sinh dạng chuỗi
  bool _isMale = true; // Giới tính mặc định

  // Lấy thông tin người dùng khi khởi tạo màn hình
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await UserStorage.getUserData();
    final userToken = await UserStorage.getUserToken(); // Lấy token từ storage
    if (userData != null && userToken != null) {
      setState(() {
        userId = userData['id']; // ID người dùng
        token = userToken; // Token người dùng
        _nameController.text = userData['name'] ?? "";
        _emailController.text = userData['email'] ?? "";
        _phoneController.text = userData['phone'] ?? "";
        _selectedDateString = userData['birthday']; // Ngày sinh dưới dạng chuỗi
        _isMale = userData['gender'] ?? true;
        _avatarUrl = userData['avatar']; // Lấy URL ảnh đại diện
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
      initialDate: _selectedDateString != null
          ? DateTime.tryParse(_selectedDateString!) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDateString = pickedDate.toIso8601String(); // Lưu ngày sinh dưới dạng chuỗi
      });
    }
  }

  // Phương thức tải ảnh lên server
  Future<String?> _uploadAvatar() async {
    if (_image == null) return null;

    try {
      final dio = ApiClient().dio;
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(_image!.path, filename: 'avatar.jpg'),
      });

      final response = await dio.post(
        '/api/users/avatar/$userId',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final avatarUrl = response.data['avatar']; // Giả sử API trả về URL ảnh
        return avatarUrl;
      } else {
        throw Exception('Tải ảnh thất bại');
      }
    } catch (e) {
      print('Lỗi tải ảnh: $e');
      return null;
    }
  }

  // Phương thức lưu thông tin cập nhật
  Future<void> _saveChanges() async {
    if (userId == null || token == null) return; // Nếu không có ID người dùng hoặc token thì không xử lý

    // Lấy thông tin người dùng từ UserStorage
    final userData = await UserStorage.getUserData();
    if (userData == null) return; // Trả về nếu không có dữ liệu người dùng

    // Sử dụng giá trị từ controller nếu có, nếu không sẽ lấy từ UserStorage
    String name = _nameController.text.isNotEmpty ? _nameController.text : userData['name'] ?? '';
    String email = _emailController.text.isNotEmpty ? _emailController.text : userData['email'] ?? '';
    String phone = _phoneController.text.isNotEmpty ? _phoneController.text : userData['phone'] ?? '';
    String birthday = _selectedDateString ?? userData['birthday'] ?? ''; // Lấy chuỗi ngày sinh
    bool gender = _isMale;
    String role = userData['role'] ?? ""; // Mặc định là USER nếu không có
    String avatar = _avatarUrl ?? userData['avatar'] ?? ""; // Lấy ảnh cũ nếu không chọn ảnh mới

    // Nếu có ảnh mới, tải lên trước
    if (_image != null) {
      String? newAvatarUrl = await _uploadAvatar();
      if (newAvatarUrl != null) {
        avatar = newAvatarUrl; // Cập nhật URL ảnh đại diện
      }
    }

    try {
      // Gửi yêu cầu cập nhật tới server thông qua UserService với token
      ApiClient().setAuthorizationToken(token!); // Cung cấp token

      final updatedUser = await _userService.updateUser(
        userId!,
        name: name,
        email: email,
        phone: phone,
        birthday: birthday, // Gửi ngày sinh dưới dạng chuỗi
        gender: gender,
        password: userData['password'] ?? "", // Giữ nguyên mật khẩu
        avatar: avatar, // Avatar là URL đã cập nhật
        role: role,
      );
      // Cập nhật thông tin người dùng trong SharedPreferences
      Map<String, dynamic> updatedUserData = {
        'id': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'birthday': birthday,
        'gender': gender,
        'role': role,
        'avatar': avatar,
      };
      await UserStorage.saveUserData(updatedUserData, token!);
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
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider
                    : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                    ? NetworkImage(_avatarUrl!)
                    : AssetImage("assets/images/avata.png")) as ImageProvider,
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
                    text: _selectedDateString != null
                        ? "${DateTime.parse(_selectedDateString!).day}/${DateTime.parse(_selectedDateString!).month}/${DateTime.parse(_selectedDateString!).year}"
                        : "Chưa chọn",
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

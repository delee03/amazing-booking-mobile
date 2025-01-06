import 'dart:async';

import 'package:flutter/material.dart';
import '../../../data/models/user_storage.dart';
import '../../../data/services/auth_service.dart';
import '../auth/login_screen.dart';
import 'booking_history_screen.dart';
import 'edit_profile_screen.dart';
import 'comment_history_screen.dart'; // Import màn hình comment

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

// Enum để theo dõi trạng thái loading
enum LoadingState { initial, loading, loaded, error }

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables
  Map<String, dynamic>? userData;
  bool isLoggedIn = false;
  LoadingState loadingState = LoadingState.initial;
  String errorMessage = '';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeData();
    // Thiết lập auto refresh token và data
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeData() async {
    if (loadingState == LoadingState.loading) return;

    setState(() {
      loadingState = LoadingState.loading;
      errorMessage = '';
    });

    try {
      // Kiểm tra đăng nhập và load data song song
      final results = await Future.wait([
        AuthService().isLoggedIn(),
        UserStorage.getUserData(),
      ]);

      if (mounted) {
        setState(() {
          isLoggedIn = results[0] as bool;
          userData = results[1] as Map<String, dynamic>?;
          loadingState = LoadingState.loaded;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loadingState = LoadingState.error;
          errorMessage = 'Không thể tải dữ liệu. Vui lòng thử lại.';
        });
      }
      _scheduleRetry();
    }
  }

  void _setupAutoRefresh() {
    // Tự động refresh data mỗi 5 phút
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (isLoggedIn) {
        _refreshData();
      }
    });
  }

  Future<void> _refreshData() async {
    if (!mounted) return;

    try {
      final token = await UserStorage.getUserToken();
      if (token == null) {
        // Token không tồn tại hoặc hết hạn
        await _handleLogout();
        return;
      }

      final newUserData = await UserStorage.getUserData();
      if (mounted) {
        setState(() {
          userData = newUserData;
        });
      }
    } catch (e) {
      if (mounted) {
        // Xử lý lỗi khi refresh
        _showErrorSnackbar('Không thể cập nhật dữ liệu');
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      await AuthService().logout();
      await UserStorage.clearUserData();
      if (mounted) {
        setState(() {
          isLoggedIn = false;
          userData = null;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Đăng xuất thất bại');
    }
  }

  void _scheduleRetry() {
    // Tự động thử lại sau 5 giây nếu load thất bại
    Future.delayed(const Duration(seconds: 5), () {
      if (loadingState == LoadingState.error && mounted) {
        _initializeData();
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildLoadingState() {
    switch (loadingState) {
      case LoadingState.initial:
      case LoadingState.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadingState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage),
              ElevatedButton(
                onPressed: _initializeData,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );
      case LoadingState.loaded:
        return _buildProfileContent();
    }
  }

  Widget _buildProfileContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            if (userData != null) ...[
              const SizedBox(height: 10),
              Text(
                userData!['name'] ?? "Chưa có tên",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
            const SizedBox(height: 20),
            _buildNavigationCards(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Stack(
        children: [
          _buildAvatar(),
          if (isLoggedIn) _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 50,
      backgroundImage: _getAvatarImage(),
      onBackgroundImageError: (exception, stackTrace) {
        print('Error loading avatar: $exception');
        // Fallback to default avatar
        setState(() {
          userData = {...userData!, 'avatar': null};
        });
      },
    );
  }

  ImageProvider _getAvatarImage() {
    if (userData?['avatar'] != null && userData!['avatar'].isNotEmpty) {
      return NetworkImage(userData!['avatar']);
    }
    return const AssetImage("assets/images/avata.png");
  }

  Widget _buildNavigationCards() {
    return Column(
      children: [
        _buildInfoBox(
          title: "Lịch sử đặt phòng",
          subtitle: "Lịch sử đặt phòng gần đây",
          icon: Icons.history,
          onTap: () => _handleNavigation(() async {
            if (!isLoggedIn) {
              _navigateToLogin();
              return;
            }

            try {
              final token = await UserStorage.getUserToken();
              if (token == null) throw Exception('Token not found');

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingHistoryScreen(
                    userId: userData!['id'],
                    token: token,
                  ),
                ),
              );
            } catch (e) {
              _showErrorSnackbar('Không thể truy cập lịch sử đặt phòng');
            }
          }),
        ),
        const SizedBox(height: 10),
        _buildInfoBox(
          title: "Bình luận",
          subtitle: "Các bình luận gần đây",
          icon: Icons.comment,
          onTap: () => _handleNavigation(() async {
            if (!isLoggedIn) {
              _navigateToLogin();
              return;
            }

            try {
              final token = await UserStorage.getUserToken();
              if (token == null) throw Exception('Token not found');

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentHistoryScreen(
                    userId: userData!['id'],
                    token: token,
                  ),
                ),
              );
            } catch (e) {
              _showErrorSnackbar('Không thể truy cập lịch sử bình luận');
            }
          }),
        ),
      ],
    );
  }

  Widget _buildInfoBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function() onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            height: 100,
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFEF4444)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFFEF4444),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Material(
        color: const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _handleNavigation(() {
            if (isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              ).then((_) => _refreshData());
            } else {
              _navigateToLogin();
            }
          }),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Hồ sơ",
        style: TextStyle(color: Color(0xFFEF4444)),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Color(0xFFEF4444)),
      actions: [
        IconButton(
          icon: Icon(
            isLoggedIn ? Icons.logout : Icons.login,
            color: const Color(0xFFEF4444),
          ),
          onPressed: () {
            if (isLoggedIn) {
              _showLogoutConfirmDialog();
            } else {
              _navigateToLogin();
            }
          },
        ),
      ],
    );
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    ).then((_) => _initializeData());
  }

  Future<void> _handleNavigation(Function() navigation) async {
    if (loadingState == LoadingState.loading) {
      return;
    }

    try {
      navigation();
    } catch (e) {
      _showErrorSnackbar('Có lỗi xảy ra. Vui lòng thử lại.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildLoadingState(),
    );
  }
}

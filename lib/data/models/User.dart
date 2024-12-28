class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final DateTime birthday;
  final bool gender;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.birthday,
    required this.gender,
    required this.phone,
    required this.role,
  });

  // Factory Constructor for JSON Parsing
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown User',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      birthday: DateTime.parse(json['birthday'] ?? DateTime.now().toString()),
      gender: json['gender'] ?? true,
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'USER',
    );
  }

  // Convert Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'birthday': birthday.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'role': role,
    };
  }
}

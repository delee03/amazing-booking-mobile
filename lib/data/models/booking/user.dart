class User {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String? avatar;
  final String? address;
  final String? fullName;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.avatar,
    this.address,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      address: json['address'],
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'address': address,
        'fullName': fullName,
      };
}

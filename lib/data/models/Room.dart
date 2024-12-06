class Room {
  final String id;
  final String name;
  final String description;
  final int soLuong;
  final int soKhach;
  final String tienNghi;
  final int price;
  final String avatar;
  final String locationId;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.soLuong,
    required this.soKhach,
    required this.tienNghi,
    required this.price,
    required this.avatar,
    required this.locationId,
  });

  // Factory constructor để chuyển JSON thành Room object
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? '', // Tránh null bằng giá trị mặc định
      name: json['name'] ?? 'No name',
      description: json['description'] ?? 'No description',
      soLuong: json['soLuong'] ?? 0,
      soKhach: json['soKhach'] ?? 0,
      tienNghi: json['tienNghi'] ?? '',
      price: (json['price'] ?? 0),
      avatar: json['avatar'] ?? '',
      locationId: json['locationId'] ?? '',
    );
  }

  // Hàm để chuyển Room object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'soLuong': soLuong,
      'soKhach': soKhach,
      'tienNghi': tienNghi,
      'price': price,
      'avatar': avatar,
      'locationId': locationId,
    };
  }
}

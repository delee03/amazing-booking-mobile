class Room {
  final String id;
  final String name;
  final String address;
  final String avatar;
  final int soKhach;
  final int price;
  final String longitude;
  final String latitude;
  Room({
    required this.id,
    required this.name,
    required this.address,
    required this.avatar,
    required this.soKhach,
    required this.price,
    required this.longitude,
    required this.latitude,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      avatar: json['avatar'],
      soKhach: json['soKhach'],
      price: json['price'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class Room {
  final String id;
  final String name;
  final String address;
  final String avatar;

  Room({
    required this.id,
    required this.name,
    required this.address,
    required this.avatar,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        avatar: json['avatar']
    );
  }
}
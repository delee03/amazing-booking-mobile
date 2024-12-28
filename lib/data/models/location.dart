class Location {
  final String id;
  final String city;
  final String style;
  final String country;
  final String longitude;
  final String latitude;

  // Constructor
  Location({
    required this.id,
    required this.city,
    required this.style,
    required this.country,
    required this.longitude,
    required this.latitude,
  });

  // Phương thức tạo đối tượng Location từ JSON (nếu dữ liệu đến từ API)
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      city: json['city'],
      style: json['style'],
      country: json['country'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  // Phương thức chuyển đổi đối tượng Location thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'style': style,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  // Để hiển thị thông tin trong giao diện
  String getFullLocation() {
    return "$city, $style, $country";
  }
}

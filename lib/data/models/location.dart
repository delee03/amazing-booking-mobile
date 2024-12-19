class Location {
  final String id;
  final String city;
  final String style;
  final String country;
  final String longitude;
  final String latitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  Location({
    required this.id,
    required this.city,
    required this.style,
    required this.country,
    required this.longitude,
    required this.latitude,
    required this.createdAt,
    required this.updatedAt,
  });
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      city: json['city'],
      style: json['style'],
      country: json['country'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'style': style,
      'country': country,
      'longitude': longitude,
      'latitude': latitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

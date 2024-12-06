class Location {
  final String id;
  final String city;
  final String style;
  final String country;
  final String longitude;
  final String latitude;

  Location({
    required this.id,
    required this.city,
    required this.style,
    required this.country,
    required this.longitude,
    required this.latitude,
  });

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
}

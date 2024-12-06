class Hotel {
  final String id;
  final String name;
  final String description;
  final int soLuong;
  final int soKhach;
  final String tienNghi;
  final double price;
  final String avatar;
  final double averageStar;
  final String locationName; // Thêm thuộc tính locationName
  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.soLuong,
    required this.soKhach,
    required this.tienNghi,
    required this.price,
    required this.avatar,
    required this.averageStar,
    required this.locationName, // Khởi tạo thuộc tính locationName
  });
}

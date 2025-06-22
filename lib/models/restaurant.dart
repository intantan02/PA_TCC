class Restaurant {
  final String id;
  final String name;
  final String city;
  final String pictureId;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.city,
    required this.pictureId,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      pictureId: json['pictureId'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

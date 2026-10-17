class Hotel {
  final String id;
  final String name;
  final String city;
  final double lat;
  final double lng;
  final int stars;
  final int pricePerNight; // TND

  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.lat,
    required this.lng,
    required this.stars,
    required this.pricePerNight,
  });
}
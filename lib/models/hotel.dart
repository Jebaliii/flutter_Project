import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Hotel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Hotel(
      id: doc.id,
      name: d['name'] ?? '',
      city: d['city'] ?? '',
      lat: (d['lat'] as num?)?.toDouble() ?? 0,
      lng: (d['lng'] as num?)?.toDouble() ?? 0,
      stars: (d['stars'] as num?)?.toInt() ?? 3,
      pricePerNight: (d['pricePerNight'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'city': city,
    'lat': lat,
    'lng': lng,
    'stars': stars,
    'pricePerNight': pricePerNight,
  };
}

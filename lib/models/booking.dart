import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String hotelId;
  final String hotelName;
  final String city;
  final DateTime arrival;
  final DateTime departure;
  final int nights;
  final int pricePerNight;
  final int total;
  final String paymentMethod; // 'online' | 'cash'
  final String status; // 'confirmed' | 'pending' | 'cancelled'
  final DateTime? createdAt;

  const Booking({
    required this.id,
    required this.hotelId,
    required this.hotelName,
    required this.city,
    required this.arrival,
    required this.departure,
    required this.nights,
    required this.pricePerNight,
    required this.total,
    required this.paymentMethod,
    required this.status,
    this.createdAt,
  });

  factory Booking.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Booking(
      id: doc.id,
      hotelId: d['hotelId'] ?? '',
      hotelName: d['hotelName'] ?? '',
      city: d['city'] ?? '',
      arrival: (d['arrival'] as Timestamp).toDate(),
      departure: (d['departure'] as Timestamp).toDate(),
      nights: (d['nights'] ?? 0) as int,
      pricePerNight: (d['pricePerNight'] ?? 0) as int,
      total: (d['total'] ?? 0) as int,
      paymentMethod: d['paymentMethod'] ?? 'cash',
      status: d['status'] ?? 'confirmed',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
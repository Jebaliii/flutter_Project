import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/booking.dart';
import '../models/hotel.dart';
import 'app_exception.dart';
import 'firestore_guard.dart';

class BookingService {
  final _col = FirebaseFirestore.instance.collection('bookings');

  Future<void> create({
    required Hotel hotel,
    required DateTime arrival,
    required DateTime departure,
    required String paymentMethod,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw const AppException(AppErrorCode.notLoggedIn);

    final nights = departure.difference(arrival).inDays;

    // En ligne = payé donc confirmée. Espèces = en attente (payé à l'hôtel).
    final status = paymentMethod == 'online' ? 'confirmed' : 'pending';

    try {
      debugPrint('Firestore: saving booking for ${user.uid}...');
      await _col
          .add({
            'userId': user.uid,
            'userEmail': user.email,
            'hotelId': hotel.id,
            'hotelName': hotel.name,
            'city': hotel.city,
            'arrival': Timestamp.fromDate(arrival),
            'departure': Timestamp.fromDate(departure),
            'nights': nights,
            'pricePerNight': hotel.pricePerNight,
            'total': nights * hotel.pricePerNight,
            'paymentMethod': paymentMethod,
            'status': status,
            // Never store card data here.
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 10));
      debugPrint('Firestore: booking saved ($status)');
    } on TimeoutException {
      throw const AppException(AppErrorCode.firestoreTimeout);
    } on FirebaseException catch (e) {
      debugPrint('Firestore error: ${e.code} - ${e.message}');
      throw AppException.fromFirebaseCode(e.code);
    }
  }

  /// Bookings of the current user, newest first (sorted on the client
  /// to avoid needing a Firestore composite index).
  Stream<List<Booking>> watchMine() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _col.where('userId', isEqualTo: uid).snapshots().map((snap) {
      final list = snap.docs.map(Booking.fromDoc).toList();
      list.sort(
        (a, b) =>
            (b.createdAt ?? b.arrival).compareTo(a.createdAt ?? a.arrival),
      );
      return list;
    });
  }

  Future<void> cancel(String id) async {
    try {
      await _col
          .doc(id)
          .update({'status': 'cancelled'})
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const AppException(AppErrorCode.firestoreTimeout);
    } on FirebaseException catch (e) {
      debugPrint('Firestore cancel error: ${e.code} - ${e.message}');
      throw AppException.fromFirebaseCode(e.code);
    }
  }

  // ---------- Admin ----------

  /// Every booking, newest first (admin only).
  Stream<List<Booking>> watchAll() => _col.snapshots().map((snap) {
    final list = snap.docs.map(Booking.fromDoc).toList();
    list.sort(
      (a, b) => (b.createdAt ?? b.arrival).compareTo(a.createdAt ?? a.arrival),
    );
    return list;
  });

  Future<void> setStatus(String id, String status) =>
      guardFirestore('status', () => _col.doc(id).update({'status': status}));

  Future<void> delete(String id) =>
      guardFirestore('delete booking', () => _col.doc(id).delete());
}

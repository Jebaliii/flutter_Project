import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/hotels_seed.dart';
import '../models/hotel.dart';
import 'firestore_guard.dart';

/// Hotels stored in Firestore (`hotels`), managed by the admin.
class HotelService {
  final _col = FirebaseFirestore.instance.collection('hotels');

  /// Hotels from Firestore, sorted by name.
  /// [fallbackToSeed]: while the admin has not imported any hotel yet, the
  /// app keeps showing the built-in catalogue.
  Stream<List<Hotel>> watchAll({bool fallbackToSeed = false}) =>
      _col.snapshots().map((snap) {
        if (snap.docs.isEmpty && fallbackToSeed) return seedHotels;
        final list = snap.docs.map(Hotel.fromDoc).toList();
        list.sort((a, b) => a.name.compareTo(b.name));
        return list;
      });

  /// Copies the built-in catalogue to Firestore (same ids, so existing
  /// bookings still point to the right hotel).
  Future<void> importSeed() => guardFirestore('import hotels', () {
    final batch = FirebaseFirestore.instance.batch();
    for (final h in seedHotels) {
      batch.set(_col.doc(h.id), h.toMap());
    }
    return batch.commit();
  });

  /// Creates the hotel when [Hotel.id] is empty, updates it otherwise.
  Future<void> save(Hotel hotel) => guardFirestore(
    'save hotel',
    () => hotel.id.isEmpty
        ? _col.add(hotel.toMap())
        : _col.doc(hotel.id).set(hotel.toMap()),
  );

  Future<void> delete(String id) =>
      guardFirestore('delete hotel', () => _col.doc(id).delete());
}

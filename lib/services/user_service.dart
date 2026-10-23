import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'firestore_guard.dart';

class UserService {
  final _col = FirebaseFirestore.instance.collection('users');

  /// Code required to register as an administrator. Override it with
  /// `--dart-define=ADMIN_CODE=...`.
  static const adminCode = String.fromEnvironment(
    'ADMIN_CODE',
    defaultValue: 'ADMIN2026',
  );

  /// Creates the profile on first sign-in, and returns it.
  /// [role] is only used when the profile does not exist yet (or has no role).
  Future<AppUser> ensureProfile(User user, {String role = 'user'}) =>
      guardFirestore('profile', () async {
        final ref = _col.doc(user.uid);
        final snap = await ref.get();
        final data = snap.data();
        if (data == null || data['role'] == null) {
          await ref.set({
            'email': user.email,
            'role': role,
            'disabled': false,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          return AppUser(uid: user.uid, email: user.email ?? '', role: role);
        }
        return AppUser.fromDoc(snap);
      });

  /// All users, newest first (admin only).
  Stream<List<AppUser>> watchAll() => _col.snapshots().map((snap) {
    final list = snap.docs.map(AppUser.fromDoc).toList();
    list.sort(
      (a, b) => (b.createdAt ?? DateTime(2000)).compareTo(
        a.createdAt ?? DateTime(2000),
      ),
    );
    return list;
  });

  Future<void> setRole(String uid, String role) =>
      guardFirestore('role', () => _col.doc(uid).update({'role': role}));

  Future<void> setDisabled(String uid, bool disabled) => guardFirestore(
    'disable',
    () => _col.doc(uid).update({'disabled': disabled}),
  );
}

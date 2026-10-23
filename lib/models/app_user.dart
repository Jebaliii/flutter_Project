import 'package:cloud_firestore/cloud_firestore.dart';

/// Profile stored in `users/{uid}` (role used for the admin interface).
class AppUser {
  final String uid;
  final String email;
  final String role; // 'admin' | 'user'
  final bool disabled;
  final DateTime? createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.disabled = false,
    this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return AppUser(
      uid: doc.id,
      email: d['email'] ?? '',
      role: d['role'] ?? 'user',
      disabled: d['disabled'] ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Runs a Firestore write with a timeout and turns errors into
/// [AppException]s (translated by `localizeError`).
Future<T> guardFirestore<T>(String label, Future<T> Function() action) async {
  try {
    return await action().timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw const AppException(AppErrorCode.firestoreTimeout);
  } on FirebaseException catch (e) {
    debugPrint('Firestore $label error: ${e.code} - ${e.message}');
    throw AppException.fromFirebaseCode(e.code);
  }
}

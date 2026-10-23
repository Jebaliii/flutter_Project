import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';

/// Screens a notification can open, sent as `data.screen` in FCM payloads.
abstract final class NotificationScreens {
  static const myBookings = 'my_bookings';
}

/// Same id as the `default_notification_channel_id` in AndroidManifest.xml,
/// so pushes received in background use this channel too.
const _channel = AndroidNotificationChannel(
  'bookings',
  'Réservations',
  description: 'Confirmations et rappels de réservation',
  importance: Importance.high,
);

final _local = FlutterLocalNotificationsPlugin();

/// Runs in a separate isolate when a push arrives while the app is in
/// background or terminated. "notification" messages are already shown by
/// the system; only data-only messages need to be displayed here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.notification != null) return;

  final title = message.data['title'] as String?;
  if (title == null) return;
  await _initLocal();
  await _showLocal(
    title: title,
    body: message.data['body'] as String?,
    data: message.data,
  );
}

Future<void> _initLocal({void Function(NotificationResponse)? onTap}) async {
  await _local.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: onTap,
  );
  await _local
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(_channel);
}

Future<void> _showLocal({
  required String title,
  String? body,
  required Map<String, dynamic> data,
}) => _local.show(
  // Unique enough for a demo app, and keeps older notifications visible.
  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  title: title,
  body: body,
  notificationDetails: NotificationDetails(
    android: AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: const DarwinNotificationDetails(),
  ),
  payload: jsonEncode(data),
);

/// Push notifications (FCM) + local notifications for in-app events.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  /// FCM is only available on mobile (not on the Windows build).
  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  final _messaging = FirebaseMessaging.instance;

  /// Called with `data.screen` when the user taps a notification.
  void Function(String screen)? _onOpen;

  /// Tap that happened before [attach] (e.g. app launched from a
  /// notification while the UI was not ready yet).
  String? _pendingScreen;

  Future<void> init() async {
    if (!isSupported) return;

    await _initLocal(onTap: (r) => _handleTap(_decode(r.payload)));

    // Android 13+ / iOS: ask for permission to display notifications.
    await _messaging.requestPermission();

    // Foreground: FCM does not display anything itself, so show it locally.
    FirebaseMessaging.onMessage.listen((message) {
      final n = message.notification;
      final title = n?.title ?? message.data['title'] as String?;
      if (title == null) return;
      debugPrint('FCM foreground: $title');
      _showLocal(
        title: title,
        body: n?.body ?? message.data['body'] as String?,
        data: message.data,
      );
    });

    // Background: the user tapped a push shown by the system.
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _handleTap(m.data));

    // Terminated: the app was launched by tapping a push...
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleTap(initial.data);

    // ...or by tapping a local notification.
    final launch = await _local.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _handleTap(_decode(launch!.notificationResponse?.payload));
    }

    _syncToken();
  }

  /// Registers the navigation callback and replays a pending tap.
  void attach(void Function(String screen) onOpen) {
    _onOpen = onOpen;
    final pending = _pendingScreen;
    if (pending != null) {
      _pendingScreen = null;
      onOpen(pending);
    }
  }

  /// Notification triggered by an action in the app (booking saved).
  Future<void> showBookingNotification({
    required String title,
    required String body,
  }) async {
    if (!isSupported) return;
    try {
      await _showLocal(
        title: title,
        body: body,
        data: const {'screen': NotificationScreens.myBookings},
      );
    } catch (e) {
      // A notification must never break the booking flow.
      debugPrint('Notification error: $e');
    }
  }

  void _handleTap(Map<String, dynamic> data) {
    final screen = data['screen'] as String?;
    if (screen == null) return;
    final onOpen = _onOpen;
    if (onOpen == null) {
      _pendingScreen = screen;
    } else {
      onOpen(screen);
    }
  }

  Map<String, dynamic> _decode(String? payload) {
    if (payload == null || payload.isEmpty) return const {};
    try {
      return Map<String, dynamic>.from(jsonDecode(payload) as Map);
    } catch (_) {
      return const {};
    }
  }

  /// Stores the device token on the user so a server (Cloud Function,
  /// Firebase console, ...) can target them.
  void _syncToken() {
    Future<void> save(String? token) async {
      final user = FirebaseAuth.instance.currentUser;
      if (token == null || user == null) return;
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'fcmTokens': FieldValue.arrayUnion([token]),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('FCM token save error: $e');
      }
    }

    Future<void> current() async {
      try {
        final token = await _messaging.getToken();
        debugPrint('FCM token: $token');
        await save(token);
      } catch (e) {
        debugPrint('FCM token error: $e');
      }
    }

    FirebaseAuth.instance.authStateChanges().listen((u) {
      if (u != null) current();
    });
    _messaging.onTokenRefresh.listen(save);
  }
}

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toy_village_app/core/router/app_router.dart';

@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}

class NotificationRoute {
  final String path;
  final int extra;

  const NotificationRoute({required this.path, required this.extra});
}

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  NotificationRoute? _pendingRoute;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    '중요 알림',
    importance: Importance.high,
  );

  Future<void> init() async {
    await _messaging.requestPermission();

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onLocalTap,
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _open(_routeFrom(message.data)),
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingRoute = _routeFrom(initialMessage.data);
    }

    final launchDetails = await _local.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _pendingRoute ??= _routeFromPayload(
        launchDetails?.notificationResponse?.payload,
      );
    }
  }

  Future<String?> token() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  NotificationRoute? takeInitialRoute() {
    final route = _pendingRoute;
    _pendingRoute = null;
    return route;
  }

  void navigate(NotificationRoute route) =>
      appRouter.push(route.path, extra: route.extra);

  int? _intOf(Map<String, dynamic> data, String key) {
    final raw = data[key];
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  NotificationRoute? _routeFrom(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'TASK_ASSIGNED':
        final id = _intOf(data, 'taskId');
        return id == null
            ? null
            : NotificationRoute(path: '/task/detail', extra: id);
      case 'TASK_COMPLETED':
        final id = _intOf(data, 'workReportId');
        return id == null
            ? null
            : NotificationRoute(path: '/task-assignment/report', extra: id);
      case 'TASK_REJECTED':
      case 'TASK_APPROVED':
        final id = _intOf(data, 'taskId');
        return id == null
            ? null
            : NotificationRoute(path: '/task/report/detail', extra: id);
      default:
        final id = _intOf(data, 'noticeId') ?? _intOf(data, 'id');
        return id == null
            ? null
            : NotificationRoute(path: '/notice/detail', extra: id);
    }
  }

  NotificationRoute? _routeFromPayload(String? payload) {
    if (payload == null) return null;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      return _routeFrom(data);
    } catch (_) {
      return null;
    }
  }

  void _open(NotificationRoute? route) {
    if (route == null) return;
    final path = appRouter.routeInformationProvider.value.uri.path;
    if (path == '/' || path == '/login') {
      _pendingRoute = route;
      return;
    }
    navigate(route);
  }

  void _onLocalTap(NotificationResponse response) {
    _open(_routeFromPayload(response.payload));
  }

  void _showForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      payload: jsonEncode(message.data),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}

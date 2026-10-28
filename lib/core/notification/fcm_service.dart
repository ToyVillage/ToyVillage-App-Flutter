import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:toy_village_app/core/router/app_router.dart';

@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {}

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  int? _pendingNoticeId;

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
      (message) => _openNotice(_noticeIdFrom(message.data)),
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingNoticeId = _noticeIdFrom(initialMessage.data);
    }

    final launchDetails = await _local.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails?.notificationResponse?.payload;
      _pendingNoticeId ??= payload == null ? null : int.tryParse(payload);
    }
  }

  Future<String?> token() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  int? takeInitialNoticeId() {
    final id = _pendingNoticeId;
    _pendingNoticeId = null;
    return id;
  }

  void navigateToNotice(int id) => appRouter.push('/notice/detail', extra: id);

  int? _noticeIdFrom(Map<String, dynamic> data) {
    final raw = data['noticeId'] ?? data['id'];
    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  void _openNotice(int? id) {
    if (id == null) return;
    navigateToNotice(id);
  }

  void _onLocalTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;
    _openNotice(int.tryParse(payload));
  }

  void _showForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      payload: _noticeIdFrom(message.data)?.toString(),
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

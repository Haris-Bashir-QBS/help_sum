import 'dart:convert';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/services/notifications/notification_navigation.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/services/connectivity_service.dart';

/// Top-level background handler. Must not be inside a class.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  if (kDebugMode) {
    debugPrint(
      '[FCM][BG] messageId=${message.messageId} title=${message.notification?.title} data=${message.data}',
    );
  }
  // Optionally handle data silently or schedule a local notification.
  await PushNotificationsService.instance._showLocalNotificationFrom(message);
}

/// Top-level background callback for local notification taps
@pragma('vm:entry-point')
Future<void> localNotificationBackgroundHandler(
  NotificationResponse response,
) async {
  await NotificationNavigation.handlePayloadTap(response.payload);
}

class PushNotificationsService {
  PushNotificationsService._internal();
  static final PushNotificationsService instance =
      PushNotificationsService._internal();

  factory PushNotificationsService() => instance;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  AndroidNotificationChannel? _androidChannel;
  static const int _maxSeenIds = 200;
  Set<String> _seenIdsMemory = <String>{};
  StreamSubscription<(dynamic, bool)>? _connectivitySub;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await _configureLocalNotifications();
    } catch (e) {
      if (kDebugMode) debugPrint('Local notifications config failed: $e');
    }

    try {
      await _requestNotificationPermissions();
    } catch (e) {
      if (kDebugMode) debugPrint('Request permission failed: $e');
    }

    try {
      await _setForegroundPresentationOptions();
    } catch (e) {
      if (kDebugMode) debugPrint('Foreground presentation options failed: $e');
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) async {
      if (kDebugMode) {
        _debugLogMessage('[FCM][FG]', message);
      }
      try {
        await _showLocalNotificationFrom(message);
      } catch (e) {
        if (kDebugMode) debugPrint('Show local notification failed: $e');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (kDebugMode) {
        _debugLogMessage('[FCM][OPENED]', message);
      }
      await NotificationNavigation.handleMessageTap(message);
    });

    try {
      final RemoteMessage? initialMessage =
          await _messaging.getInitialMessage();
      if (initialMessage != null) {
        if (kDebugMode) {
          _debugLogMessage('[FCM][INITIAL]', initialMessage);
        }
        await NotificationNavigation.handleMessageTap(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Initial message handling failed: $e');
    }

    // FCM token handling
    try {
      await _ensureFcmToken();
    } catch (e) {
      if (kDebugMode) debugPrint('Ensure FCM token failed: $e');
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
      await LocalStorageService().saveFcmToken(token);
      if (kDebugMode) debugPrint('FCM token refreshed: $token');
    });

    _initialized = true;
  }

  Future<String?> getFcmToken({bool refresh = false}) async {
    if (refresh) {
      await _messaging.deleteToken();
    }
    final token = await _messaging.getToken();
    if (kDebugMode) {
      debugPrint('FCM Token: $token');
    }
    return token;
  }

  Future<void> _ensureFcmToken() async {
    final String? existing = LocalStorageService().getFcmToken();
    if (existing != null && existing.isNotEmpty) {
      if (kDebugMode) debugPrint('Using stored FCM token');
      return;
    }
    final String? token = await _messaging.getToken();
    if (token != null && token.isNotEmpty) {
      await LocalStorageService().saveFcmToken(token);
      if (kDebugMode) debugPrint('Stored new FCM token: $token');
      return;
    }
    // No token (likely offline). Retry once connectivity is restored.
    _connectivitySub?.cancel();
    _connectivitySub = ConnectivityService.instance.connectionStatusStream
        .listen((event) async {
          final hasNetwork = event.$1.toString() != 'ConnectivityResult.none';
          if (!hasNetwork) return;
          final String? newToken = await _messaging.getToken();
          if (newToken != null && newToken.isNotEmpty) {
            await LocalStorageService().saveFcmToken(newToken);
            if (kDebugMode) {
              debugPrint('Stored new FCM token after reconnect: $newToken');
            }
            await _connectivitySub?.cancel();
            _connectivitySub = null;
          }
        });
  }

  Future<void> _requestNotificationPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (kDebugMode) {
      debugPrint('Notification permission: ${settings.authorizationStatus}');
    }

    // Android 13+ requires POST_NOTIFICATIONS runtime permission.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _setForegroundPresentationOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configureLocalNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null && response.payload!.isNotEmpty) {
          await NotificationNavigation.handlePayloadTap(response.payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: (
        NotificationResponse response,
      ) async {
        if (response.payload != null && response.payload!.isNotEmpty) {
          await localNotificationBackgroundHandler(response);
        }
      },
    );

    _androidChannel ??= const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
      playSound: true,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel!);

    // Preload seen IDs into memory for quick checks
    await _loadSeenIds();
  }

  Future<void> _showLocalNotificationFrom(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    // 🔑 Prevent duplicates:
    // If notification exists (system shows it automatically) AND there's no data payload → skip
    // If notification exists AND app is not in foreground, skip local notification (system will show it)
    if (notification != null &&
        (message.data.isEmpty || (android != null && !kIsWeb && !kDebugMode))) {
      if (kDebugMode) {
        debugPrint('[FCM][LOCAL] Skipping duplicate system notification');
      }
      return;
    }

    final String dedupeId = _deriveMessageId(message);
    if (await _hasSeenMessageId(dedupeId)) {
      if (kDebugMode) debugPrint('Duplicate notification ignored: $dedupeId');
      return;
    }

    final payload = _encodePayload(message);

    // Android specifics
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _androidChannel?.id ?? 'high_importance_channel',
          _androidChannel?.name ?? 'High Importance Notifications',
          channelDescription: _androidChannel?.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          icon: android?.smallIcon,
          ticker: AppTexts.appTitle,
        );

    // iOS specifics
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final String title =
        notification?.title ?? message.data['title'] ?? AppTexts.appTitle;
    final String body = notification?.body ?? message.data['body'] ?? '';

    if (kDebugMode) {
      debugPrint(
        '[FCM][LOCAL] showing id=$dedupeId title=$title body=$body payload=$payload',
      );
    }

    await _localNotifications.show(
      notification?.hashCode ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );

    await _recordSeenMessageId(dedupeId);
  }

  void _debugLogMessage(String prefix, RemoteMessage message) {
    debugPrint(
      '$prefix id=${message.messageId} title=${message.notification?.title} body=${message.notification?.body} data=${message.data}',
    );
  }

  String _encodePayload(RemoteMessage message) {
    try {
      final Map<String, dynamic> data = <String, dynamic>{
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
      };
      return jsonEncode(data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to encode payload: $e');
      }
      return '';
    }
  }

  String _deriveMessageId(RemoteMessage message) {
    final id = message.messageId;
    if (id != null && id.isNotEmpty) return id;
    // Fallback: stable hash from data/title/body
    final base = jsonEncode({
      't': message.notification?.title ?? '',
      'b': message.notification?.body ?? '',
      'd': message.data,
    });
    return base.hashCode.toString();
  }

  Future<void> _loadSeenIds() async {
    try {
      final List<String> list =
          await LocalStorageService().getSeenFcmMessageIds();
      _seenIdsMemory = list.toSet();
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to load seen IDs: $e');
    }
  }

  Future<bool> _hasSeenMessageId(String id) async {
    // Quick memory check first
    if (_seenIdsMemory.contains(id)) return true;
    // Fallback: legacy list check
    try {
      return await LocalStorageService().hasSeenFcmMessageId(id);
    } catch (_) {
      return false;
    }
  }

  Future<void> _recordSeenMessageId(String id) async {
    _seenIdsMemory.add(id);
    _capSeenIds();
    try {
      await LocalStorageService().addSeenFcmMessageId(id, max: _maxSeenIds);
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to save seen ID: $e');
    }
  }

  void _capSeenIds() {
    if (_seenIdsMemory.length <= _maxSeenIds) return;
    // We can't reliably trim a Set by age; rely on persisted list capping.
    // Optionally rebuild from storage on next launch.
  }
}

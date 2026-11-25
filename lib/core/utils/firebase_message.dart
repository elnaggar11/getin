import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';

import 'utils.dart';

class FBMessaging {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin? _notificationsPlugin;
  static bool _isInitialized = false;

  /// Holds the most recent order-status update received while the app was
  /// terminated. Consumed once by TrackorderScreen on first build.
  static FCMNotification? pendingOrderUpdate;

  static const _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
    await _setNotificationPresentationOptions();
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundNotificationHandler(
      NotificationResponse response) async {
    if (response.payload != null) {
      final data = json.decode(response.payload!);
      final notification = FCMNotification.fromMap(data);
      _handleNotificationOnClick(notification, appIsopened: false);
    }
  }

  static Future<void> initialize() async {
    if (_isInitialized) return;

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    }
    await _setupNotificationChannels();
    await _requestPermissions();
    await _configureMessagingHandlers();
    _getToken();
    try {
      await _messaging
          .subscribeToTopic("all")
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      log('Failed to subscribe to topic on init: $e');
    }

    _isInitialized = true;
  }

  static Future<void> _setupNotificationChannels() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    await _notificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
    );

    await _notificationsPlugin?.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: onBackgroundNotificationHandler,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationHandler,
    );
  }

  static Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await _setNotificationPresentationOptions();
  }

  static Future<void> _setNotificationPresentationOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false, // We handle foreground notifications ourselves
      badge: true,
      sound: true,
    );
  }

  static Future<void> _configureMessagingHandlers() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handle initial message when app is launched from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      FCMNotification notification =
          FCMNotification.fromMap(initialMessage.data);
      _handleNotificationOnClick(
        notification,
        appIsopened: false,
      );
    }

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(
        (message) => _processMessageInForeground(message, appIsOpened: true));

    // Handle messages when app is in background but opened by user
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      FCMNotification notification = FCMNotification.fromMap(message.data);
      _handleNotificationOnClick(
        notification,
        appIsopened: false,
      );
    });
  }

  static Future<void> _processMessageInForeground(RemoteMessage message,
      {required bool appIsOpened, bool showNotification = true}) async {
    log(message.data.toString(), name: "Message Data");
    log(message.notification?.title ?? "No title", name: "Notification Title");
    log(message.notification?.body ?? "No body", name: "Notification Body");

    // Don't show notification if it's a chat message for the current room
    if (_shouldSkipChatNotification(message)) {
      return;
    }

    // Show the notification
    if (showNotification) {
      await _showNotification(message);
    }
  }

  static bool _shouldSkipChatNotification(RemoteMessage message) {
    return false;
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    log(message.notification?.title ?? "No title",
        name: "showNotification Title");
    log(message.notification?.body ?? "No body", name: "showNotification Body");
    log(message.data.toString(), name: "showNotification Data");
    if (message.notification == null) return;

    await _notificationsPlugin?.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static Future<String> _getToken() async {
    final token = await _messaging.getToken();
    log(token ?? "No FCM token", name: "Firebase Token");
    Utils.FCMToken = token ?? '';
    log(Utils.FCMToken, name: "Firebase Token Utils");

    return token ?? '';
  }

  static Future<void> subscribeToClient() async {
    await _messaging.subscribeToTopic("all");
    await _messaging.subscribeToTopic("client");
    log("Subscribed to client topics");
  }

  static Future<void> unsubscribeFromClient() async {
    await _messaging.unsubscribeFromTopic("all");
    await _messaging.unsubscribeFromTopic("client");
    log("Unsubscribed from client topics");
  }

  static Future<void> subscribeToProvider() async {
    await _messaging.subscribeToTopic("all");
    await _messaging.subscribeToTopic("provider");
    log("Subscribed to provider topics");
  }

  static Future<void> unsubscribeFromProvider() async {
    await _messaging.unsubscribeFromTopic("all");
    await _messaging.unsubscribeFromTopic("provider");
    log("Unsubscribed from provider topics");
  }

  static Future<void> revokeToken() async {
    await _messaging.deleteToken();
    log("FCM token revoked", name: "Firebase Token");
  }

  static _handleNotificationOnClick(FCMNotification notification,
      {bool appIsopened = false}) {
    log(notification.type.toString(), name: "Notification Type");
    log(notification.modelId.toString(), name: "Notification ModelId");

    if (notification.type == "order" &&
        notification.orderId != null &&
        notification.orderStatus != null) {
      pendingOrderUpdate = notification;
      log('Stored pending order update: ${notification.orderId} → ${notification.orderStatus}',
          name: 'OrderStatusUpdate');
    }
  }
}

class FCMNotification {
  final String? title;
  final String? message;
  final String? type;
  final String? modelId;
  final String? orderStatus;
  final String? orderId;

  FCMNotification({
    this.title,
    this.message,
    this.type,
    this.modelId,
    this.orderStatus,
    this.orderId,
  });

  factory FCMNotification.fromMap(Map<String, dynamic> map) {
    return FCMNotification(
      title: map["title"],
      message: map["message"],
      type: map["type"],
      modelId: map["model_id"]?.toString(),
      orderStatus: map["order_status"]?.toString(),
      orderId: map["order_id"]?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "message": message,
      "type": type,
      "model_id": modelId,
      "order_status": orderStatus,
      "order_id": orderId,
    };
  }
}

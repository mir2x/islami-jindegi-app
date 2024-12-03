import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notification_status.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) return;

  if (message.data.containsKey('screen')) {
    QR.to(message.data['screen']);
  } else if (message.data.containsKey('link')) {
    final Uri url = Uri.parse(message.data['link']);
    launchUrl(url);
  }
}

Future initLocalNotifications() async {
  final localNotifications = FlutterLocalNotificationsPlugin();

  const androidSettings =
      AndroidInitializationSettings('@drawable/launcher_icon');

  const DarwinInitializationSettings iOSSettings =
      DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iOSSettings,
  );

  await localNotifications.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        handleMessage(message);
      }
    },
  );

  return localNotifications;
}

final pushNotificationProvider = FutureProvider((ref) async {
  final messaging = FirebaseMessaging.instance;

  var permission = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  if (permission.authorizationStatus == AuthorizationStatus.provisional ||
      permission.authorizationStatus == AuthorizationStatus.authorized) {
    /* try { */
    /*   final fCMToken = await messaging.getToken(); */
    /* } catch (error) { */
    /*   // connection error */
    /* } */

    await ref.read(notificationStatusProvider.notifier).updateStatus();

    final localNotifications = await initLocalNotifications();

    const AndroidNotificationChannel androidChannel =
        AndroidNotificationChannel(
      'push_notification_channel',
      'Updates',
      importance: Importance.max,
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              icon: '@drawable/launcher_icon',
              priority: Priority.max,
              enableVibration: true,
            ),
            iOS: DarwinNotificationDetails(subtitle: notification.title),
          ),
          payload: jsonEncode(message.toMap()),
        );
      }
    });
  }
});

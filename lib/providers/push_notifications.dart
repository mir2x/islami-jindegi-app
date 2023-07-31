import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
    onDidReceiveLocalNotification: (_, __, ___, payload) {
      if (payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(payload));
        handleMessage(message);
      }
    },
  );

  final initializationSettings = InitializationSettings(
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

  var settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.provisional ||
      settings.authorizationStatus == AuthorizationStatus.authorized) {
    /* try { */
    /*   final fCMToken = await messaging.getToken(); */
    /* } catch (error) { */
    /*   // connection error */
    /* } */

    final localNotifications = await initLocalNotifications();

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
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: const AndroidNotificationDetails(
              'push_notification_channel',
              'Push Notifications',
              icon: '@drawable/launcher_icon',
              priority: Priority.max,
              importance: Importance.max,
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

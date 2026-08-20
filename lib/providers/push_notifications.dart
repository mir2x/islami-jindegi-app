import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:native_app/routes/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notification_status.dart';
import '../core/services/offline_reset_service.dart';
import '../features/article/providers/article_sync_service.dart';
import '../features/bayan/providers/bayan_sync_service.dart';
import '../features/book/providers/book_sync_service.dart';
import '../features/dua/providers/dua_sync_service.dart';
import '../features/madrasah/providers/madrasah_sync_service.dart';
import '../features/malfuzat/providers/malfuzat_sync_service.dart';
import '../features/masail/providers/masail_sync_service.dart';

const contentSyncTopic = 'content-sync';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (message.data.containsKey('feature')) {
    await _syncContentFeature(message.data['feature']);
  }
}

Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) return;

  if (message.data.containsKey('screen')) {
    final route = message.data['screen'];
    if (route is String && route.isNotEmpty) {
      AppRoutes.router.push(route.startsWith('/') ? route : '/$route');
    }
  } else if (message.data.containsKey('link')) {
    final Uri url = Uri.parse(message.data['link']);
    launchUrl(url);
  } else if (message.data.containsKey('feature')) {
    await _syncContentFeature(message.data['feature']);
  }
}

/// Dispatches a "content-sync" data push straight to the matching sync
/// service, bypassing `offlineDbPrefetchProvider`'s 30-minute throttle so an
/// admin change reaches the app immediately instead of waiting for the next
/// poll. Mirrors `OfflineDbPrefetchNotifier._syncFeature` — these sync
/// service classes are plain Dart with no Riverpod dependency, so the same
/// call works whether this runs in the foreground or the background isolate
/// (see `handleBackgroundMessage`, which has no access to the app's
/// `ProviderContainer`). Does not touch the global poll throttle key, since
/// this only syncs one feature, not the full sweep.
Future<void> _syncContentFeature(String? feature) async {
  if (feature == null) return;

  final connectivity = await Connectivity().checkConnectivity();
  if (connectivity.contains(ConnectivityResult.none)) return;

  // The background isolate can reach a sync before the UI ever starts one,
  // so the one-time store reset has to be checked here too. It's a single
  // preference read once applied.
  await OfflineResetService.ensureApplied();

  try {
    await switch (feature) {
      'books' => BookSyncService().sync(),
      'duas' => DuaSyncService().sync(),
      'malfuzats' => MalfuzatSyncService().sync(),
      'articles' => ArticleSyncService().sync(),
      'madrasahs' => MadrasahSyncService().sync(),
      'masails' => MasailSyncService().sync(),
      'bayans' => BayanSyncService().sync(),
      _ => Future.value(),
    };
  } catch (_) {
    // A push-triggered sync failing silently is fine — the periodic poll
    // fallback will pick up the same change on its next pass.
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
    settings: initializationSettings,
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
    await messaging.subscribeToTopic(contentSyncTopic);

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

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'prayer_alarm_plan.dart';
import 'timezone_database.dart';

/// A scheduled-notification safety net behind the `alarm` package, on iOS only.
///
/// On iOS the `alarm` package rings from an in-process `Timer` kept alive by a
/// silent background audio session. When iOS terminates the app — the user
/// swipes it away, or the system reclaims memory — every pending timer dies
/// with it and no azan ever plays. That is what the package's
/// `warningNotificationOnKill` is warning the user about, and no amount of
/// Dart-side scheduling changes it.
///
/// A `UNNotificationRequest` is scheduled by the operating system and fires
/// whether or not the app exists, so one is registered alongside every planned
/// alarm. It cannot loop a three-minute adhan — iOS caps a notification sound
/// at 30 seconds — so this is a shorter, quieter alert. It is the difference
/// between a short azan and complete silence.
///
/// Android is deliberately excluded: `AlarmManager` plus the package's boot
/// receiver already survives app death there, so a second alert would only
/// double up.
class PrayerAlarmBackstop {
  PrayerAlarmBackstop._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Fired this long after the alarm the backstop is covering.
  ///
  /// A dead man's switch: if the app is alive, the `alarm` package rings at T,
  /// the ring reaches Dart within milliseconds, and [cancelForOccurrence]
  /// removes the pending notification well before T+grace. If the app is gone,
  /// nothing cancels it and it fires. The delay is what distinguishes "the
  /// azan is already playing" from "nothing happened", and it is short enough
  /// to be imperceptible as a prayer reminder.
  static const Duration _grace = Duration(seconds: 15);

  /// Offsets backstop notification ids out of the alarm id range so the two
  /// schemes can never collide.
  static const int _idOffset = 500000;

  static bool get _isSupported => Platform.isIOS;

  static Future<void> initialize() async {
    if (!_isSupported || _initialized) return;

    // No Android settings block: this never schedules on Android, and passing
    // one would claim an initialization the app already performs elsewhere for
    // push notifications.
    const settings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        // The alarm screen owns the permission prompt, so the plugin must not
        // raise its own at an arbitrary moment.
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  /// Rewrites the pending backstop notifications to match [planned].
  ///
  /// Cancels its own ids wholesale first. Unlike the alarm diff this is safe to
  /// do bluntly: a pending notification is inert until it fires, so cancelling
  /// and re-adding one interrupts nothing.
  static Future<void> sync(List<PlannedPrayerAlarm> planned) async {
    if (!_isSupported) return;
    await initialize();

    try {
      await _cancelAll();

      for (final alarm in planned) {
        await _plugin.zonedSchedule(
          id: _backstopId(alarm.id),
          title: alarm.title,
          body: alarm.body,
          scheduledDate: _asTZDateTime(alarm.dateTime.add(_grace)),
          notificationDetails: const NotificationDetails(
            iOS: DarwinNotificationDetails(
              sound: _soundFileName,
              presentAlert: true,
              presentSound: true,
              interruptionLevel: InterruptionLevel.timeSensitive,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } catch (error, stackTrace) {
      // The backstop failing must never take the primary alarm path down with
      // it — a missing bundled sound or a revoked permission is a degraded
      // alert, not a scheduling failure.
      debugPrint('[PrayerAlarm] Backstop sync failed: $error\n$stackTrace');
    }
  }

  /// Drops the notification covering [alarmId] because that alarm has just
  /// rung, so the app is alive and the azan is already playing.
  static Future<void> cancelForOccurrence(int alarmId) async {
    if (!_isSupported) return;
    try {
      await _plugin.cancel(id: _backstopId(alarmId));
    } catch (error) {
      debugPrint('[PrayerAlarm] Backstop cancel failed: $error');
    }
  }

  /// Clears the backstop for a prayer that has just been switched off.
  ///
  /// Nothing here maps an id back to a prayer, so this drops every pending
  /// backstop and leaves it to the next [sync] to re-add the ones still wanted.
  /// The caller always re-plans afterwards.
  static Future<void> cancelForPrayer(String prayerKey) async {
    if (!_isSupported) return;
    try {
      await _cancelAll();
    } catch (error) {
      debugPrint('[PrayerAlarm] Backstop clear failed: $error');
    }
  }

  static Future<void> _cancelAll() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (request.id >= _idOffset) {
        await _plugin.cancel(id: request.id);
      }
    }
  }

  static int _backstopId(int alarmId) => _idOffset + alarmId;

  /// `zonedSchedule` requires a `TZDateTime`. Planned times already are one,
  /// in the prayer location's zone; anything else is converted through its
  /// instant so the notification lands at the same moment as the alarm.
  static tz.TZDateTime _asTZDateTime(DateTime dateTime) {
    if (dateTime is tz.TZDateTime) return dateTime;
    ensureTimezoneDatabase();
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Must be a sound bundled with the iOS app target — a Flutter asset is not
  /// reachable from `UNNotificationSound`, and iOS silently falls back to the
  /// default alert tone when the name does not resolve. See
  /// `ios/Runner/Sounds/README.md`.
  static const String _soundFileName = 'azan_short.caf';
}

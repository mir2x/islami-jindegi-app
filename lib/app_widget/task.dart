import 'dart:io' show Platform;

import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';
import 'update_data.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Android only. The iOS side of the `alarm` package registers once per
    // process, bound to the main engine's messenger, so a call from this
    // engine has no handler to reach: Alarm.init() throws and, unguarded,
    // took updateData() down with it. iOS needs no top-up here anyway: a
    // background refresh launches the app, and main() re-plans on every
    // launch and resume.
    if (Platform.isAndroid) {
      // Deliberately first, and in its own guard. Topping up the alarm
      // horizon used to be the last statement of updateData(), behind a dozen
      // HomeWidget platform calls — so a widget write failing on one device
      // silently stopped that device's prayer alarms from ever being
      // extended. Widget freshness is cosmetic; a missed azan is not.
      try {
        // The background isolate never runs main(), so the alarm package must
        // be initialized here before anything touches Alarm.
        await Alarm.init();
        await PrayerAlarmService.scheduleAllAlarms();
        debugPrint('[BackgroundTask] scheduleAllAlarms() completed');
      } catch (error, stackTrace) {
        debugPrint('[BackgroundTask] scheduleAllAlarms() failed: '
            '$error\n$stackTrace');
      }
    }

    return await updateData();
  });
}

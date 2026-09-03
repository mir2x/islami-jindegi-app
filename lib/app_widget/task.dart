import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';
import 'update_data.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // The background isolate never runs main(), so the alarm package must be
    // initialized here before anything touches Alarm.
    await Alarm.init();

    // Deliberately first, and in its own guard. Topping up the alarm horizon
    // used to be the last statement of updateData(), behind a dozen
    // HomeWidget platform calls — so a widget write failing on one device
    // silently stopped that device's prayer alarms from ever being extended.
    // Widget freshness is cosmetic; a missed azan is not.
    try {
      await PrayerAlarmService.scheduleAllAlarms();
      debugPrint('[BackgroundTask] scheduleAllAlarms() completed');
    } catch (error, stackTrace) {
      debugPrint('[BackgroundTask] scheduleAllAlarms() failed: '
          '$error\n$stackTrace');
    }

    return await updateData();
  });
}

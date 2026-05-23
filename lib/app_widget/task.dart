import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'update_data.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // The background isolate never runs main(), so the alarm package must be
    // initialized here before any Alarm.set() calls inside updateData().
    await Alarm.init();
    debugPrint('[BackgroundTask] Alarm.init() done, running updateData()');
    return await updateData();
  });
}

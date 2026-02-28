import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/services/prayer_alarm_service.dart';

// ───────────────────── Alarm Enabled States ─────────────────────

class PrayerAlarmNotifier extends AsyncNotifier<Map<String, bool>> {
  @override
  Future<Map<String, bool>> build() async {
    return await PrayerAlarmService.getAllAlarmStates();
  }

  Future<void> toggleAlarm(String prayerKey, bool enabled) async {
    await PrayerAlarmService.toggleAlarm(prayerKey, enabled);
    state = AsyncValue.data(await PrayerAlarmService.getAllAlarmStates());
  }

  Future<void> toggleAllAlarms(bool enabled) async {
    await PrayerAlarmService.toggleAllAlarms(enabled);
    state = AsyncValue.data(await PrayerAlarmService.getAllAlarmStates());
  }

  Future<void> refresh() async {
    state = AsyncValue.data(await PrayerAlarmService.getAllAlarmStates());
  }
}

final prayerAlarmProvider =
    AsyncNotifierProvider<PrayerAlarmNotifier, Map<String, bool>>(() {
  return PrayerAlarmNotifier();
});

// ───────────────────── Before Offset ─────────────────────

class PrayerBeforeOffsetNotifier extends FamilyAsyncNotifier<int, String> {
  @override
  Future<int> build(String arg) async {
    return await PrayerAlarmService.getBeforeOffset(arg);
  }

  Future<void> setOffset(int minutes) async {
    await PrayerAlarmService.setBeforeOffset(arg, minutes);
    state = AsyncValue.data(minutes);
  }
}

final prayerBeforeOffsetProvider =
    AsyncNotifierProvider.family<PrayerBeforeOffsetNotifier, int, String>(() {
  return PrayerBeforeOffsetNotifier();
});

// ───────────────────── After Offset ─────────────────────

class PrayerAfterOffsetNotifier extends FamilyAsyncNotifier<int, String> {
  @override
  Future<int> build(String arg) async {
    return await PrayerAlarmService.getAfterOffset(arg);
  }

  Future<void> setOffset(int minutes) async {
    await PrayerAlarmService.setAfterOffset(arg, minutes);
    state = AsyncValue.data(minutes);
  }
}

final prayerAfterOffsetProvider =
    AsyncNotifierProvider.family<PrayerAfterOffsetNotifier, int, String>(() {
  return PrayerAfterOffsetNotifier();
});

// ───────────────────── Custom Sound ─────────────────────

class AlarmSoundNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return await PrayerAlarmService.getCustomSound();
  }

  Future<void> setSound(String? path) async {
    await PrayerAlarmService.setCustomSound(path);
    state = AsyncValue.data(path);
  }
}

final alarmSoundProvider =
    AsyncNotifierProvider<AlarmSoundNotifier, String?>(() {
  return AlarmSoundNotifier();
});

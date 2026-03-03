import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';

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

// ───────────────────── Repeat Days ─────────────────────

class PrayerRepeatDaysNotifier
    extends FamilyAsyncNotifier<Set<int>, String> {
  @override
  Future<Set<int>> build(String arg) async {
    return await PrayerAlarmService.getRepeatDays(arg);
  }

  Future<void> setDays(Set<int> days) async {
    await PrayerAlarmService.setRepeatDays(arg, days);
    state = AsyncValue.data(days.isEmpty ? {1, 2, 3, 4, 5, 6, 7} : days);
  }
}

final prayerRepeatDaysProvider =
    AsyncNotifierProvider.family<PrayerRepeatDaysNotifier, Set<int>, String>(
        () {
  return PrayerRepeatDaysNotifier();
});

// ───────────────────── Azan Sound ─────────────────────

class AlarmSoundNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return await PrayerAlarmService.getSoundKey();
  }

  Future<void> setSound(String soundKey) async {
    await PrayerAlarmService.setSoundKey(soundKey);
    state = AsyncValue.data(soundKey);
  }
}

final alarmSoundProvider =
    AsyncNotifierProvider<AlarmSoundNotifier, String>(() {
  return AlarmSoundNotifier();
});

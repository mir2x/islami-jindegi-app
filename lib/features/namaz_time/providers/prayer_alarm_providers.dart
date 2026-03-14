import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';
import 'package:permission_handler/permission_handler.dart';

// ───────────────────── Alarm Enabled States ─────────────────────

class PrayerAlarmNotifier extends AsyncNotifier<Map<String, bool>> {
  @override
  Future<Map<String, bool>> build() async {
    return await PrayerAlarmService.getAllAlarmStates();
  }

  Future<void> toggleAlarm(String prayerKey, bool enabled) async {
    await PrayerAlarmService.toggleAlarm(prayerKey, enabled);
    state = AsyncValue.data(await PrayerAlarmService.getAllAlarmStates());
    ref.invalidate(prayerAlarmScheduleProvider(prayerKey));
    ref.invalidate(nextEnabledPrayerAlarmProvider);
  }

  Future<void> toggleAllAlarms(bool enabled) async {
    await PrayerAlarmService.toggleAllAlarms(enabled);
    state = AsyncValue.data(await PrayerAlarmService.getAllAlarmStates());
    for (final prayerKey in PrayerAlarmService.prayerKeys) {
      ref.invalidate(prayerAlarmScheduleProvider(prayerKey));
    }
    ref.invalidate(nextEnabledPrayerAlarmProvider);
  }

  Future<void> refresh() async {
    state = AsyncValue.data(await PrayerAlarmService.getAllAlarmStates());
  }
}

final prayerAlarmProvider =
    AsyncNotifierProvider<PrayerAlarmNotifier, Map<String, bool>>(() {
  return PrayerAlarmNotifier();
});

// ───────────────────── Reminder Mode ─────────────────────

class PrayerReminderModeNotifier extends FamilyAsyncNotifier<String, String> {
  @override
  Future<String> build(String arg) async {
    return await PrayerAlarmService.getReminderMode(arg);
  }

  Future<void> setMode(String mode) async {
    await PrayerAlarmService.setReminderMode(arg, mode);
    state = AsyncValue.data(mode);
    ref.invalidate(prayerAlarmScheduleProvider(arg));
    ref.invalidate(nextEnabledPrayerAlarmProvider);
  }
}

final prayerReminderModeProvider = AsyncNotifierProvider.family<
    PrayerReminderModeNotifier, String, String>(() {
  return PrayerReminderModeNotifier();
});

// ───────────────────── Reminder Offset ─────────────────────

class PrayerReminderOffsetNotifier extends FamilyAsyncNotifier<int, String> {
  @override
  Future<int> build(String arg) async {
    return await PrayerAlarmService.getReminderOffset(arg);
  }

  Future<void> setOffset(int minutes) async {
    await PrayerAlarmService.setReminderOffset(arg, minutes);
    state = AsyncValue.data(minutes);
    ref.invalidate(prayerAlarmScheduleProvider(arg));
    ref.invalidate(nextEnabledPrayerAlarmProvider);
  }
}

final prayerReminderOffsetProvider = AsyncNotifierProvider.family<
    PrayerReminderOffsetNotifier, int, String>(() {
  return PrayerReminderOffsetNotifier();
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
    ref.invalidate(prayerAlarmScheduleProvider(arg));
    ref.invalidate(nextEnabledPrayerAlarmProvider);
  }
}

final prayerRepeatDaysProvider =
    AsyncNotifierProvider.family<PrayerRepeatDaysNotifier, Set<int>, String>(
        () {
  return PrayerRepeatDaysNotifier();
});

// ───────────────────── Per Prayer Sound ─────────────────────

class PrayerAlarmSoundNotifier extends FamilyAsyncNotifier<String, String> {
  @override
  Future<String> build(String arg) async {
    return await PrayerAlarmService.getSoundKey(arg);
  }

  Future<void> setSound(String soundKey) async {
    await PrayerAlarmService.setSoundKey(arg, soundKey);
    state = AsyncValue.data(soundKey);
    ref.invalidate(prayerAlarmScheduleProvider(arg));
  }
}

final prayerAlarmSoundProvider = AsyncNotifierProvider.family<
    PrayerAlarmSoundNotifier, String, String>(() {
  return PrayerAlarmSoundNotifier();
});

// ───────────────────── Schedule Preview ─────────────────────

final prayerAlarmScheduleProvider =
    FutureProvider.family<PrayerAlarmScheduleInfo?, String>((ref, prayerKey) async {
  return PrayerAlarmService.getNextScheduledAlarmInfo(
    prayerKey,
    locale: 'bn',
  );
});

final nextEnabledPrayerAlarmProvider =
    FutureProvider<PrayerAlarmScheduleInfo?>((ref) async {
  return PrayerAlarmService.getNextEnabledAlarmInfo(locale: 'bn');
});

// ───────────────────── Exact Alarm Permission ─────────────────────

class ExactAlarmPermissionNotifier extends AsyncNotifier<PermissionStatus> {
  @override
  Future<PermissionStatus> build() async {
    return await Permission.scheduleExactAlarm.status;
  }

  Future<void> updateStatus() async {
    state = AsyncValue.data(await Permission.scheduleExactAlarm.status);
  }
}

final exactAlarmPermissionProvider =
    AsyncNotifierProvider<ExactAlarmPermissionNotifier, PermissionStatus>(() {
  return ExactAlarmPermissionNotifier();
});

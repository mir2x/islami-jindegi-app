import 'dart:io' show Platform;
import 'package:alarm/alarm.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/objects/prayer_time.dart';

/// Core service for managing prayer alarms using the `alarm` package.
/// Handles scheduling, cancellation, persistence, and background rescheduling.
class PrayerAlarmService {
  PrayerAlarmService._();

  /// The 5 main prayers that support alarms
  static const List<String> prayerKeys = [
    'fajr',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  /// Deterministic alarm IDs per prayer
  /// Before-waqt alarms: 101-105
  /// After-waqt alarms: 201-205
  static const Map<String, int> _beforeAlarmIds = {
    'fajr': 101,
    'dhuhr': 102,
    'asr': 103,
    'maghrib': 104,
    'isha': 105,
  };

  static const Map<String, int> _afterAlarmIds = {
    'fajr': 201,
    'dhuhr': 202,
    'asr': 203,
    'maghrib': 204,
    'isha': 205,
  };

  /// Available azan sound asset paths
  static const List<Map<String, String>> azanSounds = [
    {
      'key': 'default',
      'path': 'assets/sounds/azan_default.mp3',
      'labelEn': 'Default Azan',
      'labelBn': 'ডিফল্ট আযান',
    },
    {
      'key': 'fajr',
      'path': 'assets/sounds/azan_fajr.mp3',
      'labelEn': 'Fajr Azan',
      'labelBn': 'ফজরের আযান',
    },
    {
      'key': 'full',
      'path': 'assets/sounds/azan_full.mp3',
      'labelEn': 'Full Azan',
      'labelBn': 'পূর্ণ আযান',
    },
    {
      'key': 'short',
      'path': 'assets/sounds/azan_short.mp3',
      'labelEn': 'Short Azan',
      'labelBn': 'সংক্ষিপ্ত আযান',
    },
  ];

  static const String defaultSoundKey = 'default';
  static const String reminderModeAt = 'at';
  static const String reminderModeBefore = 'before';
  static const String reminderModeAfter = 'after';
  static const List<int> reminderOffsetChoices = [5, 10, 15, 20, 30, 45, 60];

  /// Maximum offset in minutes for the slider
  static const int maxOffsetMinutes = 60;

  // ───────────────────── Initialization ─────────────────────

  /// Initialize the alarm service. Must be called during app startup.
  static Future<void> initialize() async {
    await Alarm.init();
  }

  // ───────────────────── Preference Keys ─────────────────────

  static String _enabledKey(String prayerKey) => 'alarm_${prayerKey}_enabled';
  static String _beforeKey(String prayerKey) => 'alarm_${prayerKey}_before';
  static String _afterKey(String prayerKey) => 'alarm_${prayerKey}_after';
  static String _modeKey(String prayerKey) => 'alarm_${prayerKey}_mode';
  static String _soundKey(String prayerKey) => 'alarm_${prayerKey}_sound_key';
  static String _repeatDaysKey(String prayerKey) =>
      'alarm_${prayerKey}_repeat_days';
  static const String _legacySoundKey = 'alarm_sound_key';

  // ───────────────────── State Getters ─────────────────────

  static Future<bool> isAlarmEnabled(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey(prayerKey)) ?? false;
  }

  static Future<int> getBeforeOffset(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_beforeKey(prayerKey)) ?? 0;
  }

  static Future<int> getAfterOffset(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_afterKey(prayerKey)) ?? 0;
  }

  static Future<String> getReminderMode(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();
    final storedMode = prefs.getString(_modeKey(prayerKey));
    if (storedMode != null) {
      return storedMode;
    }

    final before = prefs.getInt(_beforeKey(prayerKey)) ?? 0;
    final after = prefs.getInt(_afterKey(prayerKey)) ?? 0;
    if (before > 0) return reminderModeBefore;
    if (after > 0) return reminderModeAfter;
    return reminderModeAt;
  }

  static Future<int> getReminderOffset(String prayerKey) async {
    final mode = await getReminderMode(prayerKey);
    switch (mode) {
      case reminderModeBefore:
        return getBeforeOffset(prayerKey);
      case reminderModeAfter:
        return getAfterOffset(prayerKey);
      default:
        return 0;
    }
  }

  /// Returns selected repeat days as a Set of weekday ints (1=Mon … 7=Sun).
  /// Default is all 7 days.
  static Future<Set<int>> getRepeatDays(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_repeatDaysKey(prayerKey));
    if (stored == null) return {1, 2, 3, 4, 5, 6, 7};
    return stored.map(int.parse).toSet();
  }

  /// Returns the selected sound key (defaults to 'default')
  static Future<String> getSoundKey(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_soundKey(prayerKey)) ??
        prefs.getString(_legacySoundKey) ??
        defaultSoundKey;
  }

  static String getSoundPath(String soundKey) {
    final match = azanSounds.firstWhere(
      (s) => s['key'] == soundKey,
      orElse: () => azanSounds.first,
    );
    return match['path']!;
  }

  static Future<Map<String, bool>> getAllAlarmStates() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, bool> states = {};
    for (var key in prayerKeys) {
      states[key] = prefs.getBool(_enabledKey(key)) ?? false;
    }
    return states;
  }

  // ───────────────────── State Setters ─────────────────────

  static Future<void> toggleAlarm(String prayerKey, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey(prayerKey), enabled);

    if (enabled) {
      await _scheduleAlarmsForPrayer(prayerKey);
    } else {
      await cancelAlarm(prayerKey);
    }
  }

  static Future<void> toggleAllAlarms(bool enabled) async {
    for (var key in prayerKeys) {
      await toggleAlarm(key, enabled);
    }
  }

  static Future<void> setBeforeOffset(String prayerKey, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_beforeKey(prayerKey), minutes);
    await prefs.setString(
      _modeKey(prayerKey),
      minutes > 0 ? reminderModeBefore : reminderModeAt,
    );
    if (minutes > 0) {
      await prefs.setInt(_afterKey(prayerKey), 0);
    }

    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  static Future<void> setAfterOffset(String prayerKey, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_afterKey(prayerKey), minutes);
    await prefs.setString(
      _modeKey(prayerKey),
      minutes > 0 ? reminderModeAfter : reminderModeAt,
    );
    if (minutes > 0) {
      await prefs.setInt(_beforeKey(prayerKey), 0);
    }

    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  /// Saves repeat days. Pass an empty set to mean "every day".
  static Future<void> setRepeatDays(String prayerKey, Set<int> days) async {
    final prefs = await SharedPreferences.getInstance();
    // Empty = every day — store all 7
    final toStore = days.isEmpty ? {1, 2, 3, 4, 5, 6, 7} : days;
    await prefs.setStringList(
      _repeatDaysKey(prayerKey),
      toStore.map((d) => d.toString()).toList(),
    );

    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  static Future<void> setReminderMode(String prayerKey, String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey(prayerKey), mode);

    if (mode == reminderModeAt) {
      await prefs.setInt(_beforeKey(prayerKey), 0);
      await prefs.setInt(_afterKey(prayerKey), 0);
    } else if (mode == reminderModeBefore) {
      final currentBefore = prefs.getInt(_beforeKey(prayerKey)) ?? 10;
      await prefs.setInt(
        _beforeKey(prayerKey),
        currentBefore == 0 ? 10 : currentBefore,
      );
      await prefs.setInt(_afterKey(prayerKey), 0);
    } else if (mode == reminderModeAfter) {
      final currentAfter = prefs.getInt(_afterKey(prayerKey)) ?? 0;
      await prefs.setInt(_afterKey(prayerKey), currentAfter == 0 ? 10 : currentAfter);
      await prefs.setInt(_beforeKey(prayerKey), 0);
    }

    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  static Future<void> setReminderOffset(String prayerKey, int minutes) async {
    final mode = await getReminderMode(prayerKey);
    if (mode == reminderModeBefore) {
      await setBeforeOffset(prayerKey, minutes);
      return;
    }
    if (mode == reminderModeAfter) {
      await setAfterOffset(prayerKey, minutes);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_beforeKey(prayerKey), 0);
    await prefs.setInt(_afterKey(prayerKey), 0);
    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  static Future<void> setSoundKey(String prayerKey, String soundKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_soundKey(prayerKey), soundKey);
    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  // ───────────────────── Scheduling ─────────────────────

  /// Schedule all enabled alarms for the next valid occurrence.
  /// Called from app startup and background workmanager task.
  static Future<void> scheduleAllAlarms() async {
    for (var key in prayerKeys) {
      if (await isAlarmEnabled(key)) {
        await _scheduleAlarmsForPrayer(key);
      }
    }
  }

  /// Cancel all alarms for a specific prayer
  static Future<void> cancelAlarm(String prayerKey) async {
    final beforeId = _beforeAlarmIds[prayerKey];
    final afterId = _afterAlarmIds[prayerKey];

    if (beforeId != null) {
      await Alarm.stop(beforeId);
    }
    if (afterId != null) {
      await Alarm.stop(afterId);
    }
  }

  /// Cancel all prayer alarms
  static Future<void> cancelAllAlarms() async {
    for (var key in prayerKeys) {
      await cancelAlarm(key);
    }
  }

  /// Schedule both before and after alarms for a specific prayer.
  /// Each alarm is scheduled against the next valid occurrence based on the
  /// selected repeat days and the current time.
  static Future<void> _scheduleAlarmsForPrayer(String prayerKey) async {
    // First cancel existing alarms for this prayer
    await cancelAlarm(prayerKey);

    final repeatDays = await getRepeatDays(prayerKey);

    final mode = await getReminderMode(prayerKey);
    final offset = await getReminderOffset(prayerKey);
    String soundKey = await getSoundKey(prayerKey);
    String soundPath = getSoundPath(soundKey);

    final prefs = await SharedPreferences.getInstance();
    String locale = prefs.getString('locale') ?? 'bn';
    String prayerLabel = _getPrayerLabel(prayerKey, locale);

    if (mode == reminderModeBefore && offset > 0) {
      final beforeTime = await _getNextScheduledDateTime(
        prayerKey: prayerKey,
        repeatDays: repeatDays,
        offsetMinutes: -offset,
      );

      if (beforeTime != null) {
        await _setAlarm(
          id: _beforeAlarmIds[prayerKey]!,
          dateTime: beforeTime,
          title: prayerLabel,
          body: locale == 'bn'
              ? '$prayerLabel শুরু হতে $offset মিনিট বাকি'
              : '$prayerLabel starts in $offset minutes',
          soundPath: soundPath,
        );
      }
    }

    if (mode == reminderModeAt || mode == reminderModeAfter) {
      final afterTime = await _getNextScheduledDateTime(
        prayerKey: prayerKey,
        repeatDays: repeatDays,
        offsetMinutes: mode == reminderModeAfter ? offset : 0,
      );

      if (afterTime != null) {
        await _setAlarm(
          id: _afterAlarmIds[prayerKey]!,
          dateTime: afterTime,
          title: prayerLabel,
          body: locale == 'bn'
              ? mode == reminderModeAfter
                  ? '$prayerLabel এর $offset মিনিট পরে'
                  : '$prayerLabel এর সময় হয়েছে'
              : mode == reminderModeAfter
                  ? '$offset minutes after $prayerLabel'
                  : 'Time for $prayerLabel',
          soundPath: soundPath,
        );
      }
    }
  }

  /// Set a single alarm using the alarm package
  static Future<void> _setAlarm({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
    required String soundPath,
  }) async {
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: soundPath,
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: const Duration(seconds: 5),
      ),
      notificationSettings: NotificationSettings(
        title: title,
        body: body,
        stopButton: 'Stop',
        icon: 'launcher_icon',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<DateTime?> _getNextScheduledDateTime({
    required String prayerKey,
    required Set<int> repeatDays,
    required int offsetMinutes,
  }) async {
    final now = DateTime.now();

    for (int dayOffset = 0; dayOffset <= 7; dayOffset++) {
      final candidateDate = now.add(Duration(days: dayOffset));
      if (!repeatDays.contains(candidateDate.weekday)) {
        continue;
      }

      final prayerTime = await _getPrayerTime(
        prayerKey,
        date: candidateDate,
      );
      if (prayerTime == null) {
        continue;
      }

      final scheduledTime = prayerTime.add(Duration(minutes: offsetMinutes));
      if (scheduledTime.isAfter(now)) {
        return scheduledTime;
      }
    }

    return null;
  }

  static Future<PrayerAlarmScheduleInfo?> getNextScheduledAlarmInfo(
    String prayerKey, {
    String locale = 'bn',
  }) async {
    if (!await isAlarmEnabled(prayerKey)) {
      return null;
    }

    final repeatDays = await getRepeatDays(prayerKey);
    final mode = await getReminderMode(prayerKey);
    final offset = await getReminderOffset(prayerKey);
    final soundKey = await getSoundKey(prayerKey);

    final prayerTime = await _getNextPrayerOccurrence(
      prayerKey: prayerKey,
      repeatDays: repeatDays,
    );
    if (prayerTime == null) {
      return null;
    }

    final scheduledTime = await _getNextScheduledDateTime(
      prayerKey: prayerKey,
      repeatDays: repeatDays,
      offsetMinutes: switch (mode) {
        reminderModeBefore => -offset,
        reminderModeAfter => offset,
        _ => 0,
      },
    );
    if (scheduledTime == null) {
      return null;
    }

    return PrayerAlarmScheduleInfo(
      prayerKey: prayerKey,
      prayerLabel: _getPrayerLabel(prayerKey, locale),
      mode: mode,
      offsetMinutes: offset,
      soundKey: soundKey,
      nextPrayerTime: prayerTime,
      nextTriggerAt: scheduledTime,
    );
  }

  static Future<PrayerAlarmScheduleInfo?> getNextEnabledAlarmInfo({
    String locale = 'bn',
  }) async {
    PrayerAlarmScheduleInfo? earliest;
    for (final prayerKey in prayerKeys) {
      final info = await getNextScheduledAlarmInfo(prayerKey, locale: locale);
      if (info == null) continue;
      if (earliest == null ||
          info.nextTriggerAt.isBefore(earliest.nextTriggerAt)) {
        earliest = info;
      }
    }
    return earliest;
  }

  static Future<DateTime?> _getNextPrayerOccurrence({
    required String prayerKey,
    required Set<int> repeatDays,
  }) async {
    final now = DateTime.now();

    for (int dayOffset = 0; dayOffset <= 7; dayOffset++) {
      final candidateDate = now.add(Duration(days: dayOffset));
      if (!repeatDays.contains(candidateDate.weekday)) {
        continue;
      }

      final prayerTime = await _getPrayerTime(prayerKey, date: candidateDate);
      if (prayerTime != null && prayerTime.isAfter(now)) {
        return prayerTime;
      }
    }

    return null;
  }

  static Future<void> scheduleTestAlarm(
    String prayerKey, {
    String locale = 'bn',
  }) async {
    final alarmId = 900 + prayerKeys.indexOf(prayerKey);
    await Alarm.stop(alarmId);

    final prayerLabel = _getPrayerLabel(prayerKey, locale);
    final soundPath = getSoundPath(await getSoundKey(prayerKey));
    await _setAlarm(
      id: alarmId,
      dateTime: DateTime.now().add(const Duration(seconds: 8)),
      title: prayerLabel,
      body: locale == 'bn'
          ? 'এটি $prayerLabel অ্যালার্মের পরীক্ষামূলক নোটিফিকেশন'
          : 'This is a test alarm for $prayerLabel',
      soundPath: soundPath,
    );
  }

  static String formatScheduleSummary(
    PrayerAlarmScheduleInfo info,
    String locale,
  ) {
    final time = DateFormat.jm(locale).format(info.nextTriggerAt);
    return switch (info.mode) {
      reminderModeBefore => locale == 'bn'
          ? '$time, ${info.offsetMinutes} মিনিট আগে'
          : '$time, ${info.offsetMinutes} min before',
      reminderModeAfter => locale == 'bn'
          ? '$time, ${info.offsetMinutes} মিনিট পরে'
          : '$time, ${info.offsetMinutes} min after',
      _ => locale == 'bn' ? '$time, ওয়াক্তের সময়' : '$time, at waqt',
    };
  }

  // ───────────────────── Prayer Time Calculation ─────────────────────

  /// Get the prayer time for a given key using the adhan package
  static Future<DateTime?> _getPrayerTime(
    String prayerKey, {
    DateTime? date,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    double? lat = double.tryParse(prefs.getString('latitude') ?? '');
    double? lng = double.tryParse(prefs.getString('longitude') ?? '');

    if (lat == null || lng == null) {
      // Default Dhaka coordinates
      lat = 23.8103;
      lng = 90.4125;
    }

    final coordinates = Coordinates(lat, lng);
    final prayerTime = PrayerTime(
      coordinates: coordinates,
      timezone: prefs.getString('timezone') ?? '',
      preferences: prefs,
      currentDate: date ?? DateTime.now(),
    );
    return prayerTime.getPrayerStartDateTime(
      prayerKey,
      date: date ?? DateTime.now(),
    );
  }

  // ───────────────────── Prayer Labels ─────────────────────

  static String _getPrayerLabel(String prayerKey, String locale) {
    if (locale == 'bn') {
      switch (prayerKey) {
        case 'fajr':
          return 'ফজর';
        case 'dhuhr':
          return 'যুহর';
        case 'asr':
          return 'আসর';
        case 'maghrib':
          return 'মাগরিব';
        case 'isha':
          return 'ইশা';
        default:
          return prayerKey;
      }
    } else {
      switch (prayerKey) {
        case 'fajr':
          return 'Fajr';
        case 'dhuhr':
          return 'Dhuhr';
        case 'asr':
          return 'Asr';
        case 'maghrib':
          return 'Maghrib';
        case 'isha':
          return 'Isha';
        default:
          return prayerKey;
      }
    }
  }

  /// Get localized label for a prayer key (public version using AppLocalizations)
  static String getPrayerDisplayLabel(String prayerKey, String locale) {
    return _getPrayerLabel(prayerKey, locale);
  }
}

class PrayerAlarmScheduleInfo {
  final String prayerKey;
  final String prayerLabel;
  final String mode;
  final int offsetMinutes;
  final String soundKey;
  final DateTime nextPrayerTime;
  final DateTime nextTriggerAt;

  const PrayerAlarmScheduleInfo({
    required this.prayerKey,
    required this.prayerLabel,
    required this.mode,
    required this.offsetMinutes,
    required this.soundKey,
    required this.nextPrayerTime,
    required this.nextTriggerAt,
  });
}

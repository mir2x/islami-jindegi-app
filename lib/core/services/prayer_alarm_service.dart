import 'dart:async';
import 'dart:io' show Platform;
import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/core/services/prayer_alarm_backstop.dart';
import 'package:native_app/core/services/prayer_alarm_plan.dart';
import 'package:native_app/core/services/timezone_resolver.dart';
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

  /// Ids from when exactly one alarm was armed per prayer.
  ///
  /// Nothing schedules into this range any more; they survive only so an
  /// upgrading install can cancel whatever the old scheme left pending. Without
  /// that, a stale 101-205 alarm would keep firing alongside the new schedule
  /// and no code would ever clean it up.
  static const Map<String, int> _legacyBeforeAlarmIds = {
    'fajr': 101,
    'dhuhr': 102,
    'asr': 103,
    'maghrib': 104,
    'isha': 105,
  };

  static const Map<String, int> _legacyAfterAlarmIds = {
    'fajr': 201,
    'dhuhr': 202,
    'asr': 203,
    'maghrib': 204,
    'isha': 205,
  };

  static const String _legacyIdsClearedKey = 'alarm_legacy_ids_cleared';

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
    await PrayerAlarmBackstop.initialize();
    _listenForRings();
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
      await scheduleAllAlarms();
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
      await scheduleAllAlarms();
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
      await scheduleAllAlarms();
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
      await scheduleAllAlarms();
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
      await scheduleAllAlarms();
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
      await scheduleAllAlarms();
    }
  }

  static Future<void> setSoundKey(String prayerKey, String soundKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_soundKey(prayerKey), soundKey);
    if (await isAlarmEnabled(prayerKey)) {
      await scheduleAllAlarms();
    }
  }

  // ───────────────────── Scheduling ─────────────────────

  /// How many days of alarms stay armed at once.
  ///
  /// The scheduler used to arm exactly one alarm per prayer. The `alarm`
  /// package deletes an alarm from storage the moment it rings, so after every
  /// azan the chain depended on something re-arming it — the app being opened,
  /// or a periodic background task. Neither is guaranteed: OEM battery managers
  /// routinely kill WorkManager, and iOS may withhold a background refresh for
  /// days. That is why alarms "worked once and then stopped".
  ///
  /// Arming a week ahead removes the dependency entirely: with no background
  /// execution at all and the app never opened, the alarms still fire.
  ///
  /// Eight days, not seven. The window starts today, so with seven a reminder
  /// set for a single weekday has exactly one candidate — today — and once
  /// that has passed the plan is empty until something re-runs. The eighth day
  /// guarantees every weekday appears at least once still ahead.
  ///
  /// The same figure on both platforms. iOS holds each pending alarm as an
  /// in-process timer and each backstop as a scheduled notification; 5 prayers
  /// × 8 days is 40, comfortably inside the 64-notification limit iOS enforces.
  static const int _maxHorizonDays = 8;

  static int get _horizonDays => _maxHorizonDays;

  static const int _alarmIdBase = 1000;
  static const int _slotBefore = 0;
  static const int _slotAt = 1;
  static const int _slotsPerPrayer = 2;

  static const int _managedIdCount =
      5 * _slotsPerPrayer * _maxHorizonDays; // 5 == prayerKeys.length

  /// Days elapsed since a fixed epoch, modulo the id space.
  ///
  /// Deliberately derived from the calendar date rather than from the position
  /// in the horizon: a given date then always maps to the same id, so
  /// re-planning after an alarm has fired leaves every surviving alarm's id
  /// unchanged and the diff below has nothing to do. Position-based indices
  /// would shift by one each day and re-arm the whole week every time.
  static int _dayIndexFor(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day)
          .difference(DateTime.utc(2000))
          .inDays %
      _maxHorizonDays;

  static int _alarmId(String prayerKey, int slot, DateTime date) =>
      _alarmIdBase +
      ((prayerKeys.indexOf(prayerKey) * _slotsPerPrayer) + slot) *
          _maxHorizonDays +
      _dayIndexFor(date);

  /// Whether an id belongs to this scheduler, so a diff never disturbs the test
  /// alarm or anything another part of the app might arm.
  static bool _isManagedAlarmId(int id) =>
      id >= _alarmIdBase && id < _alarmIdBase + _managedIdCount;

  /// Brings the armed set in line with what the settings currently ask for.
  ///
  /// Idempotent by construction: it plans the full horizon, compares that
  /// against what the `alarm` package already holds, and touches only the ids
  /// whose time actually changed. In the steady state this does nothing at all,
  /// which is what makes it safe to call on every app resume and every
  /// background tick.
  ///
  /// A ringing alarm is never stopped. `Alarm.stop` on one sends STOP_ALARM to
  /// the foreground service and silences the azan mid-play — the reason opening
  /// the app during the adhan used to cut it off.
  static Future<void> scheduleAllAlarms() async {
    await _cancelLegacyAlarmsOnce();

    final planned = await planAlarms();
    final plannedById = {for (final alarm in planned) alarm.id: alarm};

    final existing = await Alarm.getAlarms();
    final existingById = {
      for (final alarm in existing)
        if (_isManagedAlarmId(alarm.id)) alarm.id: alarm,
    };

    for (final alarm in existing) {
      if (!_isManagedAlarmId(alarm.id)) continue;
      final wanted = plannedById[alarm.id];
      if (wanted != null &&
          wanted.dateTime.isAtSameMomentAs(alarm.dateTime)) {
        continue;
      }
      if (await Alarm.isRinging(alarm.id)) continue;
      await Alarm.stop(alarm.id);
    }

    for (final alarm in planned) {
      final current = existingById[alarm.id];
      if (current != null && current.dateTime.isAtSameMomentAs(alarm.dateTime)) {
        continue;
      }
      if (await Alarm.isRinging(alarm.id)) continue;
      await _setAlarm(
        id: alarm.id,
        dateTime: alarm.dateTime,
        title: alarm.title,
        body: alarm.body,
        soundPath: alarm.soundPath,
      );
    }

    await PrayerAlarmBackstop.sync(planned);
  }

  /// Every alarm that should be armed across the horizon, earliest first.
  ///
  /// Exposed for tests and for the backstop; arming is a separate step.
  static Future<List<PlannedPrayerAlarm>> planAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString('locale') ?? 'bn';
    final calculator = await _prayerCalculator();
    final now = DateTime.now();

    final planned = <PlannedPrayerAlarm>[];

    for (final prayerKey in prayerKeys) {
      if (!await isAlarmEnabled(prayerKey)) continue;

      final repeatDays = await getRepeatDays(prayerKey);
      final mode = await getReminderMode(prayerKey);
      final offset = await getReminderOffset(prayerKey);
      final soundKey = await getSoundKey(prayerKey);
      final soundPath = getSoundPath(soundKey);
      final label = _getPrayerLabel(prayerKey, locale);

      // A prayer has one reminder at a time, so only one of the two slots is
      // ever occupied. Both ids exist so switching mode does not collide with
      // the alarm the previous mode left armed.
      final slot = mode == reminderModeBefore ? _slotBefore : _slotAt;
      final offsetMinutes = switch (mode) {
        reminderModeBefore => -offset,
        reminderModeAfter => offset,
        _ => 0,
      };

      for (final date in _horizonDates(calculator)) {
        if (!repeatDays.contains(date.weekday)) continue;

        final prayerTime =
            calculator.getPrayerStartDateTime(prayerKey, date: date);
        if (prayerTime == null) continue;

        final firesAt = prayerTime.add(Duration(minutes: offsetMinutes));
        if (!firesAt.isAfter(now)) continue;

        planned.add(
          PlannedPrayerAlarm(
            id: _alarmId(prayerKey, slot, date),
            prayerKey: prayerKey,
            dateTime: firesAt,
            title: label,
            body: _reminderBody(label, mode, offset, locale),
            soundPath: soundPath,
            soundKey: soundKey,
          ),
        );
      }
    }

    planned.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return planned;
  }

  static String _reminderBody(
    String prayerLabel,
    String mode,
    int offset,
    String locale,
  ) {
    if (mode == reminderModeBefore) {
      return locale == 'bn'
          ? '$prayerLabel শুরু হতে $offset মিনিট বাকি'
          : '$prayerLabel starts in $offset minutes';
    }
    if (mode == reminderModeAfter) {
      return locale == 'bn'
          ? '$prayerLabel এর $offset মিনিট পরে'
          : '$offset minutes after $prayerLabel';
    }
    return locale == 'bn' ? '$prayerLabel এর সময় হয়েছে' : 'Time for $prayerLabel';
  }

  /// Cancels anything the previous one-alarm-per-prayer scheme left pending.
  ///
  /// Runs once per install. The old ids fall outside the managed range, so the
  /// diff in [scheduleAllAlarms] deliberately ignores them and they would
  /// otherwise ring forever alongside the new schedule.
  static Future<void> _cancelLegacyAlarmsOnce() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_legacyIdsClearedKey) ?? false) return;

    for (final id in [
      ..._legacyBeforeAlarmIds.values,
      ..._legacyAfterAlarmIds.values,
    ]) {
      if (await Alarm.isRinging(id)) continue;
      await Alarm.stop(id);
    }

    await prefs.setBool(_legacyIdsClearedKey, true);
  }

  /// Cancel all alarms for a specific prayer, across the whole horizon.
  static Future<void> cancelAlarm(String prayerKey) async {
    final prayerIndex = prayerKeys.indexOf(prayerKey);
    if (prayerIndex < 0) return;

    for (var slot = 0; slot < _slotsPerPrayer; slot++) {
      for (var dayIndex = 0; dayIndex < _maxHorizonDays; dayIndex++) {
        final id = _alarmIdBase +
            ((prayerIndex * _slotsPerPrayer) + slot) * _maxHorizonDays +
            dayIndex;
        if (await Alarm.isRinging(id)) continue;
        await Alarm.stop(id);
      }
    }

    await PrayerAlarmBackstop.cancelForPrayer(prayerKey);
  }

  /// Cancel all prayer alarms
  static Future<void> cancelAllAlarms() async {
    for (var key in prayerKeys) {
      await cancelAlarm(key);
    }
  }

  /// Re-plans after an alarm fires.
  ///
  /// The `alarm` package removes an alarm from storage once it rings, so the
  /// horizon loses its front entry on every azan. Topping up here keeps the
  /// full week armed instead of letting it drain one day at a time between
  /// app launches. Only reaches Dart while an isolate is alive, which is why it
  /// is a supplement to the horizon and not a replacement for it.
  static StreamSubscription<AlarmSet>? _ringSubscription;
  static Set<int> _lastRingingIds = const {};

  static void _listenForRings() {
    _ringSubscription ??= Alarm.ringing.listen((ringing) async {
      final currentIds = ringing.alarms.map((alarm) => alarm.id).toSet();
      // The stream reports the whole ringing set on every change, including
      // when an alarm stops, so only ids that were not ringing a moment ago
      // count as having just fired.
      final started = currentIds.difference(_lastRingingIds);
      _lastRingingIds = currentIds;

      final managed = started.where(_isManagedAlarmId);
      if (managed.isEmpty) return;

      try {
        for (final id in managed) {
          await PrayerAlarmBackstop.cancelForOccurrence(id);
        }
        await scheduleAllAlarms();
      } catch (error, stackTrace) {
        debugPrint(
          '[PrayerAlarm] Top-up after ring failed: $error\n$stackTrace',
        );
      }
    });
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
    final calculator = await _prayerCalculator();
    final now = DateTime.now();

    for (final candidateDate in _upcomingDates(calculator, repeatDays)) {
      final prayerTime =
          calculator.getPrayerStartDateTime(prayerKey, date: candidateDate);
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
    final calculator = await _prayerCalculator();
    final now = DateTime.now();

    for (final candidateDate in _upcomingDates(calculator, repeatDays)) {
      final prayerTime =
          calculator.getPrayerStartDateTime(prayerKey, date: candidateDate);
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

  /// A calculator anchored to the stored location, with its zone resolved from
  /// the stored coordinates rather than read back blindly — an install carrying
  /// a zone from the old country-code strategy would otherwise keep scheduling
  /// alarms against it.
  static Future<PrayerTime> _prayerCalculator() async {
    final prefs = await SharedPreferences.getInstance();

    double? lat = double.tryParse(prefs.getString('latitude') ?? '');
    double? lng = double.tryParse(prefs.getString('longitude') ?? '');

    if (lat == null || lng == null) {
      // Default Dhaka coordinates
      lat = 23.8103;
      lng = 90.4125;
    }

    final timezone = await resolveTimezone(latitude: lat, longitude: lng);

    // No `currentDate`: the calculator anchors itself to "now" at the prayer
    // location. Passing the device's own clock made the reference day wrong by
    // one whenever the two calendars disagreed, which is most of the day for a
    // user half the world away.
    return PrayerTime(
      coordinates: Coordinates(lat, lng),
      timezone: timezone,
      preferences: prefs,
    );
  }

  /// Every date in the horizon, in the prayer location's calendar.
  ///
  /// The calendar has to be the prayer location's, not the device's: an alarm
  /// set for Friday means Friday where the prayer is, and a user several zones
  /// away is on a different date for much of the day.
  ///
  /// Starts at today because a prayer later today is still ahead; entries
  /// already in the past are dropped by the caller.
  static Iterable<DateTime> _horizonDates(PrayerTime calculator) sync* {
    final today = calculator.nowInPrayerTimezone;
    final anchor = DateTime.utc(today.year, today.month, today.day);

    for (int dayOffset = 0; dayOffset < _horizonDays; dayOffset++) {
      yield anchor.add(Duration(days: dayOffset));
    }
  }

  /// The horizon narrowed to the days the user asked to be reminded on.
  static Iterable<DateTime> _upcomingDates(
    PrayerTime calculator,
    Set<int> repeatDays,
  ) sync* {
    for (final date in _horizonDates(calculator)) {
      if (repeatDays.contains(date.weekday)) yield date;
    }
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

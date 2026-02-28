import 'dart:io' show Platform;
import 'package:alarm/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:timezone_utc_offset/timezone_utc_offset.dart';

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

  /// Default alarm sound asset path
  static const String defaultSoundPath = 'assets/sounds/default_alarm.mp3';

  /// Available offset options in minutes
  static const List<int> offsetOptions = [0, 5, 10, 15, 20, 30];

  // ───────────────────── Initialization ─────────────────────

  /// Initialize the alarm service. Must be called during app startup.
  static Future<void> initialize() async {
    await Alarm.init();
  }

  // ───────────────────── Preference Keys ─────────────────────

  static String _enabledKey(String prayerKey) => 'alarm_${prayerKey}_enabled';
  static String _beforeKey(String prayerKey) => 'alarm_${prayerKey}_before';
  static String _afterKey(String prayerKey) => 'alarm_${prayerKey}_after';
  static const String _customSoundKey = 'alarm_custom_sound';

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

  static Future<String?> getCustomSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_customSoundKey);
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

    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  static Future<void> setAfterOffset(String prayerKey, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_afterKey(prayerKey), minutes);

    if (await isAlarmEnabled(prayerKey)) {
      await _scheduleAlarmsForPrayer(prayerKey);
    }
  }

  static Future<void> setCustomSound(String? filePath) async {
    final prefs = await SharedPreferences.getInstance();
    if (filePath != null) {
      await prefs.setString(_customSoundKey, filePath);
    } else {
      await prefs.remove(_customSoundKey);
    }
  }

  // ───────────────────── Scheduling ─────────────────────

  /// Schedule all enabled alarms for today's prayer times.
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

  /// Schedule both before and after alarms for a specific prayer
  static Future<void> _scheduleAlarmsForPrayer(String prayerKey) async {
    // First cancel existing alarms for this prayer
    await cancelAlarm(prayerKey);

    // Get prayer time
    DateTime? prayerTime = await _getPrayerTime(prayerKey);
    if (prayerTime == null) return;

    int beforeOffset = await getBeforeOffset(prayerKey);
    int afterOffset = await getAfterOffset(prayerKey);
    String? customSound = await getCustomSound();
    String soundPath = customSound ?? defaultSoundPath;

    final prefs = await SharedPreferences.getInstance();
    String locale = prefs.getString('locale') ?? 'bn';
    String prayerLabel = _getPrayerLabel(prayerKey, locale);

    // Schedule before-waqt alarm
    if (beforeOffset > 0) {
      DateTime beforeTime =
          prayerTime.subtract(Duration(minutes: beforeOffset));

      if (beforeTime.isAfter(DateTime.now())) {
        await _setAlarm(
          id: _beforeAlarmIds[prayerKey]!,
          dateTime: beforeTime,
          title: prayerLabel,
          body: locale == 'bn'
              ? '$prayerLabel শুরু হতে $beforeOffset মিনিট বাকি'
              : '$prayerLabel starts in $beforeOffset minutes',
          soundPath: soundPath,
        );
      }
    }

    // Schedule after-waqt alarm (at exact time + offset)
    DateTime afterTime = prayerTime.add(Duration(minutes: afterOffset));

    if (afterTime.isAfter(DateTime.now())) {
      await _setAlarm(
        id: _afterAlarmIds[prayerKey]!,
        dateTime: afterTime,
        title: prayerLabel,
        body: locale == 'bn'
            ? '$prayerLabel এর সময় হয়েছে'
            : 'Time for $prayerLabel',
        soundPath: soundPath,
      );
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

  // ───────────────────── Prayer Time Calculation ─────────────────────

  /// Get the prayer time for a given key using the adhan package
  static Future<DateTime?> _getPrayerTime(String prayerKey) async {
    final prefs = await SharedPreferences.getInstance();

    double? lat = double.tryParse(prefs.getString('latitude') ?? '');
    double? lng = double.tryParse(prefs.getString('longitude') ?? '');

    if (lat == null || lng == null) {
      // Default Dhaka coordinates
      lat = 23.8103;
      lng = 90.4125;
    }

    String timezone = prefs.getString('timezone') ?? '';
    bool daylight = prefs.getBool('daylight') ?? false;
    Duration? utcOffset = timezone.isEmpty
        ? null
        : getTimezoneUTCOffset(timezone, daylight: daylight);

    final coordinates = Coordinates(lat, lng);
    final today = DateTime.now();
    final params = _getCalculationParams(prefs);

    final prayerTimes = PrayerTimes(
      coordinates,
      DateComponents(today.year, today.month, today.day),
      params,
      utcOffset: utcOffset,
    );

    switch (prayerKey) {
      case 'fajr':
        return prayerTimes.fajr;
      case 'dhuhr':
        // Dhuhr starts 5 minutes after zawal
        return prayerTimes.dhuhr.add(const Duration(minutes: 5));
      case 'asr':
        return prayerTimes.asr;
      case 'maghrib':
        return prayerTimes.maghrib;
      case 'isha':
        return prayerTimes.isha;
      default:
        return null;
    }
  }

  static CalculationParameters _getCalculationParams(SharedPreferences prefs) {
    String method = prefs.getString('method') ?? 'Karachi';
    String madhab = prefs.getString('madhab') ?? 'hanafi';

    CalculationParameters params;
    switch (method) {
      case 'Karachi':
        params = CalculationMethod.karachi.getParameters();
        break;
      case 'MuslimWorldLeague':
        params = CalculationMethod.muslim_world_league.getParameters();
        break;
      case 'UmmAlQura':
        params = CalculationMethod.umm_al_qura.getParameters();
        break;
      case 'MoonsightingCommittee':
        params = CalculationMethod.moon_sighting_committee.getParameters();
        break;
      case 'Egyptian':
        params = CalculationMethod.egyptian.getParameters();
        break;
      case 'Dubai':
        params = CalculationMethod.dubai.getParameters();
        break;
      case 'Qatar':
        params = CalculationMethod.qatar.getParameters();
        break;
      case 'Kuwait':
        params = CalculationMethod.kuwait.getParameters();
        break;
      case 'Singapore':
        params = CalculationMethod.singapore.getParameters();
        break;
      case 'Turkey':
        params = CalculationMethod.turkey.getParameters();
        break;
      default:
        params = CalculationMethod.karachi.getParameters();
    }

    params.madhab = madhab == 'shafi' ? Madhab.shafi : Madhab.hanafi;
    params.adjustments.fajr = prefs.getInt('fajr') ?? 5;
    params.adjustments.sunrise = prefs.getInt('sunrise') ?? 0;
    params.adjustments.dhuhr = prefs.getInt('dhuhr') ?? 0;
    params.adjustments.asr = prefs.getInt('asr') ?? 0;
    params.adjustments.maghrib = prefs.getInt('maghrib') ?? 3;
    params.adjustments.isha = prefs.getInt('isha') ?? 0;

    return params;
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

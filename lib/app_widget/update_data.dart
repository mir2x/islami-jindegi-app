import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:hijri/hijri_calendar.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/helpers/update_app_widget.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/split_hijri_date.dart';
import 'package:native_app/helpers/get_bangali_date.dart';
import 'package:native_app/helpers/get_gregorian_date.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';
import 'package:native_app/core/services/hijri_api.dart';

/// Localized prayer titles carry a second name after a comma
/// ("মাগরিব, ইফতার"). The countdown headline on a small home screen widget has
/// room for one name, so it uses the first.
String _shortPrayerTitle(String title) => title.split(',').first.trim();

bool _timezoneDatabaseReady = false;

/// The Workmanager and home_widget background isolates never run `main()`, so
/// the timezone database is empty there. Without it `PrayerTime` silently falls
/// back to the device clock and the widget shows times for the wrong zone.
void _ensureTimezoneDatabase() {
  if (_timezoneDatabaseReady) return;
  tz_data.initializeTimeZones();
  _timezoneDatabaseReady = true;
}

Future<bool> updateData() async {
  _ensureTimezoneDatabase();
  final preferences = await SharedPreferences.getInstance();
  var currentLang = preferences.getString('locale') ?? 'bn';
  var locales = await AppLocalizations.delegate.load(Locale(currentLang));
  final theme = switch (preferences.getString('theme')) {
    'classic' || 'light' || 'dark' => preferences.getString('theme')!,
    _ => 'classic',
  };

  initializeDateFormatting(currentLang);

  Map coordinates = await getFailSafeCoordinates();
  Map location = await getFailSafeLocation();
  String timezone = await getFailSafeTimezone();
  String locationName = getLocationName(location);
  final int hijriAdjustment = preferences.getInt('hijriLocalAdjustment') ?? 0;

  final now = DateTime.now();
  final adjustedToday = DateTime(
    now.year,
    now.month,
    now.day + hijriAdjustment,
  );
  final adjustedTomorrow = DateTime(
    now.year,
    now.month,
    now.day + hijriAdjustment + 1,
  );
  final todayStr =
      '${adjustedToday.year}-${adjustedToday.month.toString().padLeft(2, '0')}-${adjustedToday.day.toString().padLeft(2, '0')}';
  final tomorrowStr =
      '${adjustedTomorrow.year}-${adjustedTomorrow.month.toString().padLeft(2, '0')}-${adjustedTomorrow.day.toString().padLeft(2, '0')}';

  Map<String, dynamic>? hijriDataToday;
  Map<String, dynamic>? hijriDataTomorrow;
  final cachedToday = preferences.getString('hijriDataToday');
  final cachedTomorrow = preferences.getString('hijriDataTomorrow');
  if (cachedToday != null) {
    final decoded = jsonDecode(cachedToday) as Map<String, dynamic>;
    if (decoded['date'] == todayStr) hijriDataToday = decoded;
  }
  if (cachedTomorrow != null) {
    final decoded = jsonDecode(cachedTomorrow) as Map<String, dynamic>;
    if (decoded['date'] == tomorrowStr) hijriDataTomorrow = decoded;
  }

  // If cache is stale (app not opened today), fetch fresh data from backend.
  if (hijriDataToday == null || hijriDataTomorrow == null) {
    final String? countryCode = location['countryCode'] as String?;
    final String? backendUrl = preferences.getString('hijriBackendUrl');
    if (countryCode != null && backendUrl != null) {
      try {
        final api = HijriApi(backendUrl);
        final results = await Future.wait([
          api.getDate(date: todayStr, countryCode: countryCode),
          api.getDate(date: tomorrowStr, countryCode: countryCode),
        ]);
        final todayData = results[0];
        final tomorrowData = results[1];
        if (todayData != null) {
          hijriDataToday = {
            ...Map<String, dynamic>.from(todayData),
            'date': todayStr,
          };
          await preferences.setString(
            'hijriDataToday',
            jsonEncode(hijriDataToday),
          );
        }
        if (tomorrowData != null) {
          hijriDataTomorrow = {
            ...Map<String, dynamic>.from(tomorrowData),
            'date': tomorrowStr,
          };
          await preferences.setString(
            'hijriDataTomorrow',
            jsonEncode(hijriDataTomorrow),
          );
        }
      } catch (_) {
        // Network unavailable — will fall back to Umm al-Qura below.
      }
    }
  }

  HijriCalendar hijri = adjustedHijriDate({
    'preferences': preferences,
    'coordinates': coordinates,
    'timezone': timezone,
    'hijriAdjustment': hijriAdjustment,
    'hijriDataToday': hijriDataToday,
    'hijriDataTomorrow': hijriDataTomorrow,
  });

  Map h = splitHijriDate(hijri, locales, currentLang);
  String hijriDate = '${h['day']} ${h['month']}, ${h['year']}';
  String bangaliDate = getBangaliDate();
  String gregorianDate = getGregorianDate(currentLang, null);

  PrayerTime prayerTime = PrayerTime(
    coordinates: Coordinates(
      coordinates['latitude'],
      coordinates['longitude'],
    ),
    timezone: timezone,
    preferences: preferences,
  );

  Map sunriseSunset = prayerTime.getSunriseSunset(locales, currentLang);

  Map prayerTimes = prayerTime.getCurrentAndNextPrayers(
    locales,
    currentLang,
  );
  final allPrayerTimes = prayerTime.getTimes(locales, currentLang);
  final prayerSchedule = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha']
      .map(
        (key) => {
          'title': allPrayerTimes[key]!['title'],
          'time': allPrayerTimes[key]!['startTime'],
        },
      )
      .toList();
  final prayerScheduleJson = jsonEncode(prayerSchedule);

  String sunrise =
      "${sunriseSunset['sunrise']['title']} ${sunriseSunset['sunrise']['time']}";
  String sunset =
      "${sunriseSunset['sunset']['title']}  ${sunriseSunset['sunset']['time']}";

  bool hasCurrentPrayer =
      prayerTimes.containsKey('current') && (prayerTimes['current'] != null);

  String? currentPrayer;
  int countdownSeconds;
  // Which prayer the widget countdown belongs to, and whether it counts down
  // to that prayer's end (we are inside its window) or to its start.
  String countdownName;
  bool countdownEnding;
  if (hasCurrentPrayer) {
    currentPrayer =
        "${prayerTimes['current']['title']} ${prayerTimes['current']['time']}";
    countdownSeconds = prayerTimes['current']['remainingSeconds'] as int;
    countdownName = _shortPrayerTitle(prayerTimes['current']['title'] as String);
    countdownEnding = true;
  } else {
    countdownSeconds = prayerTimes['next']['remainingSeconds'] as int;
    countdownName = _shortPrayerTitle(prayerTimes['next']['title'] as String);
    countdownEnding = false;
  }
  final countdownTarget =
      DateTime.now().millisecondsSinceEpoch + (countdownSeconds * 1000);

  String nextPrayer =
      '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}';
  final nextPrayerName = prayerTimes['next']['title'] as String;
  final nextPrayerTime = prayerTimes['next']['time'] as String;

  await updateAppWidget({
    'theme': theme,
    // The iOS widget formats its live countdown itself and would otherwise
    // follow the device language, mixing Western and Bangla digits.
    'locale': currentLang,
    'hijriDate': hijriDate,
    'bangaliDate': bangaliDate,
    'gregorianDate': gregorianDate,
    'sunrise': sunrise,
    'sunset': sunset,
    'location': locationName,
    if (hasCurrentPrayer) ...{
      'currentPrayer': currentPrayer,
    },
    'countdownName': countdownName,
    'countdownEnding': countdownEnding ? '1' : '0',
    'nextPrayer': nextPrayer,
    'nextPrayerName': nextPrayerName,
    'nextPrayerTime': nextPrayerTime,
    'countdownTarget': countdownTarget.toString(),
    'prayerSchedule': prayerScheduleJson,
    // Keep individual values as well as the JSON list. Android launchers can
    // deliver an older or partially-written SharedPreferences snapshot to a
    // newly-added widget; the individual values make its display reliable.
    for (var i = 0; i < prayerSchedule.length; i++) ...{
      'schedule${i}Title': prayerSchedule[i]['title']!,
      'schedule${i}Time': prayerSchedule[i]['time']!,
    },
  });

  await preferences.setString('hijriDate', hijriDate);
  await preferences.setString('bangaliDate', bangaliDate);
  await preferences.setString('gregorianDate', gregorianDate);
  await preferences.setString('location', locationName);

  if (hasCurrentPrayer) {
    await preferences.setString('currentPrayer', currentPrayer!);
  }

  await preferences.setString('nextPrayer', nextPrayer);
  await preferences.setString('prayerSchedule', prayerScheduleJson);

  // Reschedule prayer alarms for today
  try {
    await PrayerAlarmService.scheduleAllAlarms();
    debugPrint('[BackgroundTask] scheduleAllAlarms() completed');
  } catch (e, st) {
    debugPrint('[BackgroundTask] scheduleAllAlarms() failed: $e\n$st');
  }

  return true;
}

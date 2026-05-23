import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:native_app/helpers/update_app_widget.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/split_hijri_date.dart';
import 'package:native_app/helpers/get_bangali_date.dart';
import 'package:native_app/helpers/get_gregorian_date.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/core/services/prayer_alarm_service.dart';

Future<bool> updateData() async {
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
        final dio = Dio(BaseOptions(
          baseUrl: '$backendUrl/api',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),);
        final results = await Future.wait([
          dio.get('/hijri_date', queryParameters: {'date': todayStr, 'country-code': countryCode}),
          dio.get('/hijri_date', queryParameters: {'date': tomorrowStr, 'country-code': countryCode}),
        ]);
        final todayData = results[0].data['data'];
        final tomorrowData = results[1].data['data'];
        if (todayData != null) {
          hijriDataToday = {...Map<String, dynamic>.from(todayData), 'date': todayStr};
          await preferences.setString('hijriDataToday', jsonEncode(hijriDataToday));
        }
        if (tomorrowData != null) {
          hijriDataTomorrow = {...Map<String, dynamic>.from(tomorrowData), 'date': tomorrowStr};
          await preferences.setString('hijriDataTomorrow', jsonEncode(hijriDataTomorrow));
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

  String sunrise =
      "${sunriseSunset['sunrise']['title']} ${sunriseSunset['sunrise']['time']}";
  String sunset =
      "${sunriseSunset['sunset']['title']}  ${sunriseSunset['sunset']['time']}";

  bool hasCurrentPrayer =
      prayerTimes.containsKey('current') && (prayerTimes['current'] != null);

  String? currentPrayer;

  if (hasCurrentPrayer) {
    currentPrayer =
        "${prayerTimes['current']['title']} ${prayerTimes['current']['time']}";
  }

  String nextPrayer =
      '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}';

  updateAppWidget({
    'theme': theme,
    'hijriDate': hijriDate,
    'bangaliDate': bangaliDate,
    'gregorianDate': gregorianDate,
    'sunrise': sunrise,
    'sunset': sunset,
    'location': locationName,
    if (hasCurrentPrayer) ...{
      'currentPrayer': currentPrayer,
    },
    'nextPrayer': nextPrayer,
  });

  await preferences.setString('hijriDate', hijriDate);
  await preferences.setString('bangaliDate', bangaliDate);
  await preferences.setString('gregorianDate', gregorianDate);
  await preferences.setString('location', locationName);

  if (hasCurrentPrayer) {
    await preferences.setString('currentPrayer', currentPrayer!);
  }

  await preferences.setString('nextPrayer', nextPrayer);

  // Reschedule prayer alarms for today
  try {
    await PrayerAlarmService.scheduleAllAlarms();
    debugPrint('[BackgroundTask] scheduleAllAlarms() completed');
  } catch (e, st) {
    debugPrint('[BackgroundTask] scheduleAllAlarms() failed: $e\n$st');
  }

  return true;
}

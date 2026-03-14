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

Future updateData() async {
  final preferences = await SharedPreferences.getInstance();
  var currentLang = preferences.getString('locale') ?? 'bn';
  var locales = await AppLocalizations.delegate.load(Locale(currentLang));
  const theme = 'classic';

  initializeDateFormatting(currentLang);

  Map coordinates = await getFailSafeCoordinates();
  Map location = await getFailSafeLocation();
  String timezone = await getFailSafeTimezone();
  String locationName = getLocationName(location);

  HijriCalendar hijri = adjustedHijriDate({
    'preferences': preferences,
    'coordinates': coordinates,
    'timezone': timezone,
    'hijriAdjustment': preferences.getInt('hijriAdjustment') ?? 0,
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
  } catch (_) {
    // Alarm scheduling may fail in background isolate
  }

  return Future.value();
}

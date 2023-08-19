import 'package:workmanager/workmanager.dart';
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

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final preferences = await SharedPreferences.getInstance();
    var currentLang = preferences.getString('locale') ?? 'bn';
    var locales = await AppLocalizations.delegate.load(Locale(currentLang));

    initializeDateFormatting(currentLang);

    Map coordinates = await getFailSafeCoordinates();
    Map location = await getFailSafeLocation();

    HijriCalendar hijriDate = adjustedHijriDate({
      'preferences': preferences,
      'coordinates': coordinates,
      'hijriAdjustment': preferences.getInt('hijriAdjustment') ?? 0,
    });

    Map h = splitHijriDate(hijriDate, locales, currentLang);

    PrayerTime prayerTime = PrayerTime(
      coordinates: Coordinates(
        coordinates['latitude'],
        coordinates['longitude'],
      ),
      preferences: preferences,
    );

    Map sunriseSunset = prayerTime.getSunriseSunset(locales, currentLang);

    Map prayerTimes = prayerTime.getCurrentAndNextPrayers(
      locales,
      currentLang,
    );

    String nextPrayer =
        '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}';

    updateAppWidget({
      'hijriDate': '${h['day']} ${h['month']}, ${h['year']}',
      'bangaliDate': getBangaliDate(),
      'gregorianDate': getGregorianDate(currentLang, null),
      'sunriseTitle': sunriseSunset['sunrise']['title'],
      'sunriseTime': sunriseSunset['sunrise']['time'],
      'sunsetTitle': sunriseSunset['sunset']['title'],
      'sunsetTime': sunriseSunset['sunset']['time'],
      'location': getLocationName(location),
      if (prayerTimes.containsKey('current')) ...{
        'currentPrayerTitle': prayerTimes['current']['title']
      },
      if (prayerTimes.containsKey('current')) ...{
        'currentPrayerTime': prayerTimes['current']['time']
      },
      'nextPrayer': nextPrayer,
    });

    return Future.value(true);
  });
}

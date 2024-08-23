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
    String theme = preferences.getString('theme') ?? 'classic';

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

    String nextPrayer =
        '${locales.next} ${prayerTimes['next']['title']} ${prayerTimes['next']['time']}';

    updateAppWidget({
      'theme': theme,
      'hijriDate': hijriDate,
      'bangaliDate': getBangaliDate(),
      'gregorianDate': getGregorianDate(currentLang, null),
      'sunriseTitle': sunriseSunset['sunrise']['title'],
      'sunriseTime': sunriseSunset['sunrise']['time'],
      'sunsetTitle': sunriseSunset['sunset']['title'],
      'sunsetTime': sunriseSunset['sunset']['time'],
      'location': locationName,
      if (prayerTimes.containsKey('current') &&
          prayerTimes['current'] != null) ...{
        'currentPrayerTitle': prayerTimes['current']['title'],
        'currentPrayerTime': prayerTimes['current']['time'],
      },
      'nextPrayer': nextPrayer,
    });

    await preferences.setString('hijriDate', hijriDate);
    await preferences.setString('location', locationName);

    if (prayerTimes.containsKey('current') && prayerTimes['current'] != null) {
      await preferences.setString(
        'currentPrayerTitle',
        prayerTimes['current']['title'],
      );
      await preferences.setString(
        'currentPrayerTime',
        prayerTimes['current']['time'],
      );
    }

    await preferences.setString('nextPrayer', nextPrayer);

    return Future.value(true);
  });
}

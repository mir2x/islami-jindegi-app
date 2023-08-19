import 'package:hijri/hijri_calendar.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/objects/prayer_time.dart';

HijriCalendar adjustedHijriDate(Map settings) {
  DateTime date = DateTime.now();
  DateTime adjustedToday;

  if (isAfterDateStartTime(date, settings)) {
    date = DateTime(date.year, date.month, date.day + 1);
  }

  int adjustment = settings['hijriAdjustment'];
  adjustedToday = DateTime(date.year, date.month, date.day + adjustment);

  return HijriCalendar.fromDate(adjustedToday);
}

bool isAfterDateStartTime(DateTime date, Map settings) {
  dynamic preferences = settings['preferences'];
  Map coordinates = settings['coordinates'];

  PrayerTime prayerTime = PrayerTime(
    coordinates: Coordinates(
      coordinates['latitude'],
      coordinates['longitude'],
    ),
    preferences: preferences,
  );

  DateTime dateStartTime = prayerTime.getDateStartTime();

  return date.isAfter(dateStartTime);
}

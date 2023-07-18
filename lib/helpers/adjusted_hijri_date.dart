import 'package:hijri/hijri_calendar.dart';
import 'package:adhan/adhan.dart';
import 'package:native_app/objects/prayer_time.dart';

HijriCalendar adjustedHijriDate(Map data) {
  DateTime date = DateTime.now();

  if (isAfterDateStartTime(date, data)) {
    date = DateTime(date.year, date.month, date.day + 1);
  }

  dynamic preferences = data['preferences'];
  int adjustment = preferences.getInt('hijriAdjustment') ?? 0;

  DateTime adjustedToday =
      DateTime(date.year, date.month, date.day + adjustment);

  return HijriCalendar.fromDate(adjustedToday);
}

bool isAfterDateStartTime(DateTime date, Map data) {
  Map geolocation = data['geolocation'];
  dynamic preferences = data['preferences'];
  Map coordinates = geolocation['coordinates'];

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

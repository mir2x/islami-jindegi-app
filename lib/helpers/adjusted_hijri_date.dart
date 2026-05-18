import 'package:adhan/adhan.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Returns how many columns to shift weekday labels in HijriMonthPicker so
/// that day numbers align with real-world weekdays for the user's country.
///
/// HijriMonthPicker renders its grid using Umm al-Qura (Saudi) calendar, so
/// when BD starts a month on a different day than SA, every day appears in
/// the wrong weekday column. This offset corrects that.
int hijriWeekdayShift(Map settings) {
  final hijriData = settings['hijriDataToday'];
  if (hijriData == null) return 0;

  final now = DateTime.now();
  final int bdDay = (hijriData['hijri_day'] as num).toInt();

  // BD month started this many days before today
  final bdMonthStart =
      DateTime(now.year, now.month, now.day - (bdDay - 1));

  // SA month start: ask the Umm al-Qura library what SA day it is today,
  // then subtract to reach SA day 1 of the same month
  final saToday = HijriCalendar.fromDate(now);
  final saMonthStart =
      DateTime(now.year, now.month, now.day - (saToday.hDay - 1));

  // Dart weekday: 1=Mon..7=Sun → convert to 0=Sun..6=Sat
  int toSunBased(int dartWd) => dartWd % 7;

  final bdWd = toSunBased(bdMonthStart.weekday);
  final saWd = toSunBased(saMonthStart.weekday);

  return (bdWd - saWd + 7) % 7;
}

/// Returns how many Hijri days Bangladesh differs from Umm al-Qura today.
///
/// Positive means Saudi is ahead of Bangladesh by that many Hijri days.
int hijriDayDelta(Map settings) {
  final now = DateTime.now();
  final bdToday = adjustedHijriDate(settings);
  final bdInSaudiCalendar = bdToday.hijriToGregorian(
    bdToday.hYear,
    bdToday.hMonth,
    bdToday.hDay,
  );

  final civilToday = DateTime(now.year, now.month, now.day);
  final civilBdInSaudi = DateTime(
    bdInSaudiCalendar.year,
    bdInSaudiCalendar.month,
    bdInSaudiCalendar.day,
  );

  return civilToday.difference(civilBdInSaudi).inDays;
}

HijriCalendar pickerHijriToDisplayHijri(
  Map settings,
  HijriCalendar pickerDate,
) {
  final int delta = hijriDayDelta(settings);
  return _shiftHijriByDays(pickerDate, -delta);
}

HijriCalendar displayHijriToPickerHijri(
  Map settings,
  HijriCalendar displayDate,
) {
  final int delta = hijriDayDelta(settings);
  return _shiftHijriByDays(displayDate, delta);
}

DateTime displayHijriToGregorian(
  Map settings,
  HijriCalendar displayDate,
) {
  final pickerDate = displayHijriToPickerHijri(settings, displayDate);
  return pickerDate.hijriToGregorian(
    pickerDate.hYear,
    pickerDate.hMonth,
    pickerDate.hDay,
  );
}

HijriCalendar gregorianToDisplayHijri(
  Map settings,
  DateTime gregorianDate,
) {
  return pickerHijriToDisplayHijri(
    settings,
    HijriCalendar.fromDate(gregorianDate),
  );
}

HijriCalendar adjustedHijriDate(Map settings) {
  final now = DateTime.now();
  final maghrib = getMaghribTime(settings, now);
  final bool pastMaghrib = maghrib != null && now.isAfter(maghrib);
  debugPrint('[Hijri][adjustedHijriDate] now=$now, maghrib=$maghrib, pastMaghrib=$pastMaghrib');
  final prefs = settings['preferences'] as SharedPreferences?;

  final todayData = settings['hijriDataToday'];
  final tomorrowData = settings['hijriDataTomorrow'];
  final cachedTodayData =
      prefs != null ? _readCachedHijriData(prefs, offsetDays: 0) : null;
  final cachedTomorrowData =
      prefs != null ? _readCachedHijriData(prefs, offsetDays: 1) : null;

  // After Maghrib use only tomorrow's data; never fall back to today's data
  // here — the legacy sunsetShift=1 fallback below handles the no-data case.
  final hijriData = pastMaghrib
      ? (tomorrowData ?? cachedTomorrowData)
      : (todayData ?? cachedTodayData);
  debugPrint('[Hijri][adjustedHijriDate] tomorrowData day=${tomorrowData?['hijri_day']}, hijriData day=${hijriData?['hijri_day']}');

  if (hijriData != null) {
    final cal = HijriCalendar();
    cal.hYear = (hijriData['hijri_year'] as num).toInt();
    cal.hMonth = (hijriData['hijri_month'] as num).toInt();
    cal.hDay = (hijriData['hijri_day'] as num).toInt();
    return cal;
  }

  // Fallback: legacy offset-based calculation (used when backend is unreachable
  // and no cached data is available for today).
  final int adjustment = (settings['hijriAdjustment'] as int?) ?? 0;
  final int sunsetShift = pastMaghrib ? 1 : 0;
  final adjustedToday =
      DateTime(now.year, now.month, now.day + adjustment + sunsetShift);
  return HijriCalendar.fromDate(adjustedToday);
}

HijriCalendar _shiftHijriByDays(HijriCalendar date, int days) {
  if (days == 0) return date;

  final gregorian = date.hijriToGregorian(date.hYear, date.hMonth, date.hDay);
  final shiftedGregorian = gregorian.add(Duration(days: days));
  return HijriCalendar.fromDate(shiftedGregorian);
}

/// Returns the Maghrib time for [date] as a UTC [DateTime], or null if it
/// cannot be calculated.
///
/// The adhan package, when given utcOffset, stores the offset-adjusted hours
/// inside a UTC DateTime — e.g. Dhaka Maghrib 12:36 UTC becomes
/// DateTime.utc(…,18,36), shifting the epoch 6 h forward. Omitting utcOffset
/// keeps the returned DateTime in true UTC so that isAfter(DateTime.now())
/// works correctly regardless of the device timezone.
DateTime? getMaghribTime(Map settings, DateTime date) {
  final coordinates = settings['coordinates'];
  final preferences = settings['preferences'];
  if (coordinates == null || preferences == null) return null;

  try {
    final coords = Coordinates(
      (coordinates['latitude'] as num).toDouble(),
      (coordinates['longitude'] as num).toDouble(),
    );

    final prefs = preferences as SharedPreferences;
    final method = prefs.getString('method') ?? 'Karachi';
    final params = _calculationMethod(method);
    params.adjustments.maghrib = prefs.getInt('maghrib') ?? 3;

    // No utcOffset — adhan returns a true UTC DateTime whose epoch is correct
    // for direct comparison with DateTime.now().
    final prayerTimes = PrayerTimes(
      coords,
      DateComponents(date.year, date.month, date.day),
      params,
    );

    return prayerTimes.maghrib;
  } catch (_) {
    return null;
  }
}

CalculationParameters _calculationMethod(String method) {
  switch (method) {
    case 'Karachi':
      return CalculationMethod.karachi.getParameters();
    case 'MuslimWorldLeague':
      return CalculationMethod.muslim_world_league.getParameters();
    case 'UmmAlQura':
      return CalculationMethod.umm_al_qura.getParameters();
    case 'MoonsightingCommittee':
      return CalculationMethod.moon_sighting_committee.getParameters();
    case 'Egyptian':
      return CalculationMethod.egyptian.getParameters();
    case 'Dubai':
      return CalculationMethod.dubai.getParameters();
    case 'Qatar':
      return CalculationMethod.qatar.getParameters();
    case 'Kuwait':
      return CalculationMethod.kuwait.getParameters();
    case 'Singapore':
      return CalculationMethod.singapore.getParameters();
    case 'Turkey':
      return CalculationMethod.turkey.getParameters();
    default:
      return CalculationMethod.karachi.getParameters();
  }
}

Map<String, dynamic>? _readCachedHijriData(
  SharedPreferences prefs, {
  required int offsetDays,
}) {
  final now = DateTime.now();
  final int hijriAdjustment = prefs.getInt('hijriLocalAdjustment') ?? 0;
  final targetDate = DateTime(
    now.year,
    now.month,
    now.day + hijriAdjustment + offsetDays,
  );
  final expectedDate =
      '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';
  final cacheKey = offsetDays == 0 ? 'hijriDataToday' : 'hijriDataTomorrow';
  final raw = prefs.getString(cacheKey);
  if (raw == null) return null;

  try {
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    if (decoded['date'] != expectedDate) return null;
    final cachedCountry = decoded['countryCode'] as String?;
    final currentCountry = prefs.getString('countryCode');
    if (cachedCountry != null && currentCountry != null && cachedCountry != currentCountry) return null;
    return decoded;
  } catch (_) {
    return null;
  }
}

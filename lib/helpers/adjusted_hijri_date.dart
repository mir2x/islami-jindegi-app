import 'package:adhan/adhan.dart';
import 'dart:convert';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

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

HijriCalendar adjustedHijriDate(Map settings) {
  final now = DateTime.now();
  final bool pastMaghrib = _isPastMaghrib(settings, now);
  final prefs = settings['preferences'] as SharedPreferences?;

  final todayData = settings['hijriDataToday'];
  final tomorrowData = settings['hijriDataTomorrow'];
  final cachedTodayData =
      prefs != null ? _readCachedHijriData(prefs, offsetDays: 0) : null;
  final cachedTomorrowData =
      prefs != null ? _readCachedHijriData(prefs, offsetDays: 1) : null;

  // Pick tomorrow's data after Maghrib (Islamic day already changed), else today's.
  final hijriData = pastMaghrib
      ? (tomorrowData ?? cachedTomorrowData ?? todayData ?? cachedTodayData)
      : (todayData ?? cachedTodayData);

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

bool _isPastMaghrib(Map settings, DateTime now) {
  final coordinates = settings['coordinates'];
  final preferences = settings['preferences'];
  if (coordinates == null || preferences == null) return false;

  try {
    final coords = Coordinates(
      (coordinates['latitude'] as num).toDouble(),
      (coordinates['longitude'] as num).toDouble(),
    );

    final prefs = preferences as SharedPreferences;
    final method = prefs.getString('method') ?? 'Karachi';
    final params = _calculationMethod(method);
    params.adjustments.maghrib = prefs.getInt('maghrib') ?? 3;

    final String timezone = settings['timezone'] ?? '';
    Duration? utcOffset;
    if (timezone.isNotEmpty) {
      try {
        final location = tz.getLocation(timezone);
        final tzDate = tz.TZDateTime(location, now.year, now.month, now.day);
        utcOffset = tzDate.timeZoneOffset;
      } catch (_) {}
    }

    final prayerTimes = PrayerTimes(
      coords,
      DateComponents(now.year, now.month, now.day),
      params,
      utcOffset: utcOffset,
    );

    return now.isAfter(prayerTimes.maghrib);
  } catch (_) {
    return false;
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
    return decoded['date'] == expectedDate ? decoded : null;
  } catch (_) {
    return null;
  }
}

import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

HijriCalendar adjustedHijriDate(Map settings) {
  final now = DateTime.now();
  final int adjustment = settings['hijriAdjustment'];
  final int sunsetShift = _isPastMaghrib(settings, now) ? 1 : 0;
  final adjustedToday =
      DateTime(now.year, now.month, now.day + adjustment + sunsetShift);

  return HijriCalendar.fromDate(adjustedToday);
}

/// Returns true if the current time is past Maghrib (sunset) for the
/// user's location, meaning the next Islamic day has already begun.
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
        final tzDate = tz.TZDateTime(
          location,
          now.year,
          now.month,
          now.day,
        );
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

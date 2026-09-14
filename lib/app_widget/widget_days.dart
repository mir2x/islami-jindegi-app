import 'dart:convert';

import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/helpers/get_gregorian_date.dart';
import 'package:native_app/helpers/split_hijri_date.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/objects/bongabdo.dart';
import 'package:native_app/objects/prayer_time.dart';
import 'package:timezone/timezone.dart' as tz;

/// How many days of widget data are written ahead of time.
///
/// iOS gives an app that the user does not open no background time at all —
/// `BGAppRefreshTask` is opportunistic and dries up after a few days — so the
/// home screen widget cannot rely on the app to rewrite "today". Instead the
/// app writes this many days of prayer windows and dates, and the widget
/// extension picks the right day and window for the current moment itself.
const widgetDaysAhead = 90;

/// The nine prayer windows the widget switches between, in the order
/// `PrayerTime` walks them when deciding the current and next prayer.
const _windowKeys = [
  'fajr',
  'sunrise',
  'ishraq',
  'midday',
  'dhuhr',
  'asr',
  'sunset',
  'maghrib',
  'isha',
];

const _scheduleKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

/// Builds the JSON table the iOS widget reads under the `widgetDays` key.
///
/// [prayerTime] supplies the location, timezone and calculation settings;
/// its own reference date is the first day of the table. The Hijri inputs are
/// the same ones `updateData` hands to `adjustedHijriDate`, so day one of the
/// table shows exactly what the app shows today.
String buildWidgetDaysJson({
  required PrayerTime prayerTime,
  required AppLocalizations locales,
  required String currentLang,
  required int hijriAdjustment,
  required Map<String, dynamic>? hijriDataToday,
  required Map<String, dynamic>? hijriDataTomorrow,
}) {
  final today = prayerTime.nowInPrayerTimezone;
  final firstDay = DateTime.utc(today.year, today.month, today.day);
  final hijri = _HijriResolver(
    adjustedToday: _shiftDays(firstDay, hijriAdjustment),
    todayData: hijriDataToday,
    tomorrowData: hijriDataTomorrow,
  );

  final days = List.generate(widgetDaysAhead, (offset) {
    final date = _shiftDays(firstDay, offset);
    final dayPrayers = PrayerTime(
      coordinates: prayerTime.coordinates,
      timezone: prayerTime.timezone,
      preferences: prayerTime.preferences,
      currentDate: date,
    );
    final times = dayPrayers.getTimes(locales, currentLang);
    final sun = dayPrayers.getSunriseSunset(locales, currentLang);
    final adjustedDate = _shiftDays(date, hijriAdjustment);

    return {
      'date': _isoDate(date),
      'dayStart': _localMidnight(prayerTime.location, date),
      'dayEnd': _localMidnight(prayerTime.location, _shiftDays(date, 1)),
      // The Hijri day turns over at Maghrib, not midnight; the widget picks
      // between the two using the Maghrib window below.
      'hijriDate': _formatHijri(
        hijri.forAdjustedDate(adjustedDate),
        locales,
        currentLang,
      ),
      'hijriDateAfterMaghrib': _formatHijri(
        hijri.forAdjustedDate(_shiftDays(adjustedDate, 1)),
        locales,
        currentLang,
      ),
      'bangaliDate': _bangaliDate(date),
      'gregorianDate': getGregorianDate(currentLang, date),
      'sunrise': "${sun['sunrise']!['title']} ${sun['sunrise']!['time']}",
      'sunset': "${sun['sunset']!['title']}  ${sun['sunset']!['time']}",
      'schedule': [
        for (final key in _scheduleKeys)
          {'title': times[key]!['title'], 'time': times[key]!['startTime']},
      ],
      'windows': [
        for (final key in _windowKeys)
          {
            'key': key,
            'title': times[key]!['title'],
            'shortTitle': (times[key]!['title'] as String).split(',').first.trim(),
            'startTime': times[key]!['startTime'],
            'endTime': times[key]!['endTime'],
            'start': (times[key]!['startDateTime'] as DateTime)
                .millisecondsSinceEpoch,
            'end': (times[key]!['endDateTime'] as DateTime)
                .millisecondsSinceEpoch,
          },
      ],
    };
  });

  return jsonEncode({
    'version': 1,
    'generatedAt': DateTime.now().millisecondsSinceEpoch,
    'nextLabel': locales.next,
    'days': days,
  });
}

/// Whole-day arithmetic on a UTC date so a DST change cannot shift the day.
DateTime _shiftDays(DateTime date, int days) {
  return DateTime.utc(date.year, date.month, date.day).add(Duration(days: days));
}

String _isoDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Midnight of [date] at the prayer location, in milliseconds since the epoch.
int _localMidnight(tz.Location? location, DateTime date) {
  final midnight = location == null
      ? DateTime(date.year, date.month, date.day)
      : tz.TZDateTime(location, date.year, date.month, date.day);
  return midnight.millisecondsSinceEpoch;
}

String _bangaliDate(DateTime date) {
  final day = Bongabdo.fromDate(date, 'new');
  return '${day.bDay} ${day.bMonth}, ${day.bYear} ${day.bSeason}কাল';
}

String _formatHijri(HijriCalendar date, AppLocalizations locales, String lang) {
  final parts = splitHijriDate(date, locales, lang);
  return '${parts['day']} ${parts['month']}, ${parts['year']}';
}

/// Hijri dates for the table, consistent with what the app shows today.
///
/// The backend only supplies Bangladesh's Hijri date for today and tomorrow.
/// For every other day the Umm al-Qura calendar is used, shifted by however
/// many days it disagrees with the backend for today, so the table does not
/// jump by a day where the backend data runs out.
class _HijriResolver {
  _HijriResolver({
    required this.adjustedToday,
    required this.todayData,
    required this.tomorrowData,
  }) {
    final anchor = todayData == null ? null : _fromData(todayData!);
    if (anchor == null) {
      deltaDays = 0;
      return;
    }
    final anchorGregorian =
        anchor.hijriToGregorian(anchor.hYear, anchor.hMonth, anchor.hDay);
    deltaDays = DateTime.utc(
      anchorGregorian.year,
      anchorGregorian.month,
      anchorGregorian.day,
    ).difference(adjustedToday).inDays;
  }

  final DateTime adjustedToday;
  final Map<String, dynamic>? todayData;
  final Map<String, dynamic>? tomorrowData;
  late final int deltaDays;

  HijriCalendar forAdjustedDate(DateTime date) {
    final offset = date.difference(adjustedToday).inDays;
    if (offset == 0 && todayData != null) return _fromData(todayData!);
    if (offset == 1 && tomorrowData != null) return _fromData(tomorrowData!);
    return HijriCalendar.fromDate(_shiftDays(date, deltaDays));
  }

  static HijriCalendar _fromData(Map<String, dynamic> data) {
    final calendar = HijriCalendar();
    calendar.hYear = (data['hijri_year'] as num).toInt();
    calendar.hMonth = (data['hijri_month'] as num).toInt();
    calendar.hDay = (data['hijri_day'] as num).toInt();
    return calendar;
  }
}

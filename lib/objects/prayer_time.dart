import 'dart:core';

import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:native_app/core/services/timezone_database.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerTime {
  PrayerTime({
    required this.coordinates,
    required this.timezone,
    required this.preferences,
    this.currentDate,
  }) {
    ensureTimezoneDatabase();
    location = _resolveLocation(timezone);
    referenceDate = currentDate ?? _nowInPrayerTimezone();
    _prayerTimes = _createPrayerTimes(referenceDate);
  }

  final Coordinates coordinates;
  final String timezone;
  final SharedPreferences preferences;
  final DateTime? currentDate;

  /// Null only when [timezone] is empty or names a zone the database cannot
  /// resolve. Every time this class produces then falls back to the device
  /// clock, which is right at home and silently wrong everywhere else — so the
  /// constructor logs it rather than letting it pass unnoticed.
  late final tz.Location? location;

  late final DateTime referenceDate;
  late final _DayPrayerTimes _prayerTimes;

  final Duration oneMin = const Duration(minutes: 1);
  final Duration threeMins = const Duration(minutes: 3);
  final Duration fourMins = const Duration(minutes: 4);
  final Duration fiveMins = const Duration(minutes: 5);
  final Duration tenMins = const Duration(minutes: 10);
  final Duration fourteenMins = const Duration(minutes: 14);
  final Duration fifteenMins = const Duration(minutes: 15);

  Map<String, Map<String, dynamic>> getTimes(
    AppLocalizations locales,
    String currentLang,
  ) {
    final schedule = _buildDisplaySchedule(locales, currentLang, referenceDate);
    return schedule.map((key, value) {
      return MapEntry(key, value.toMap(currentLang, _formatTime));
    });
  }

  Map<String, Map<String, String>> getSunriseSunset(
    AppLocalizations locales,
    String currentLang,
  ) {
    final schedule = _buildDisplaySchedule(locales, currentLang, referenceDate);
    return {
      'sunrise': {
        'title': schedule['sunrise']!.title,
        'time': _formatTime(schedule['sunrise']!.startDateTime, currentLang),
      },
      'sunset': {
        'title': schedule['sunset']!.title,
        'time': _formatTime(schedule['sunset']!.startDateTime, currentLang),
      },
    };
  }

  Map<String, dynamic> getCurrentAndNextPrayers(
    AppLocalizations locales,
    String currentLang,
  ) {
    final now = _nowInPrayerTimezone();
    final currentWindow = _currentPrayerWindow(now);
    final nextWindow = _nextPrayerWindow(now);
    final todaySchedule =
        _buildDisplaySchedule(locales, currentLang, referenceDate);

    return {
      if (currentWindow != null) ...{
        'current': {
          'title': _localizedPrayerTitle(currentWindow.key, locales),
          'time':
              '${_formatTime(currentWindow.startDateTime, currentLang)} - ${_formatTime(currentWindow.endDateTime, currentLang)}',
          'endsAt': currentWindow.endDateTime.millisecondsSinceEpoch,
          'remainingSeconds': currentWindow.endDateTime
              .difference(now)
              .inSeconds
              .clamp(0, 86400)
              .toInt(),
        },
      },
      'next': {
        'title': nextWindow != null
            ? _localizedPrayerTitle(nextWindow.key, locales)
            : todaySchedule['fajr']!.title,
        'time': nextWindow != null
            ? _formatTime(nextWindow.startDateTime, currentLang)
            : _formatTime(todaySchedule['fajr']!.startDateTime, currentLang),
        'startsAt': (nextWindow?.startDateTime ??
                todaySchedule['fajr']!.startDateTime)
            .millisecondsSinceEpoch,
        'remainingSeconds': (nextWindow?.startDateTime ??
                todaySchedule['fajr']!.startDateTime)
            .difference(now)
            .inSeconds
            .clamp(0, 86400)
            .toInt(),
      },
    };
  }

  Map<String, String> currentAndNextPrayerNames() {
    final now = _nowInPrayerTimezone();
    final currentWindow = _currentPrayerWindow(now);
    final nextWindow = _nextPrayerWindow(now);

    return {
      'currentPrayer': currentWindow?.key ?? 'none',
      'nextPrayer': nextWindow?.key ?? 'fajr',
    };
  }

  DateTime getDateStartTime() {
    return _prayerTimes.maghrib;
  }

  DateTime? getPrayerStartDateTime(
    String prayerKey, {
    DateTime? date,
  }) {
    final windows = _buildPrayerWindowsForDate(date ?? referenceDate);
    return windows[prayerKey]?.startDateTime;
  }

  static tz.Location? _resolveLocation(String timezone) {
    if (timezone.isEmpty) {
      debugPrint('[PrayerTime] No timezone supplied — falling back to the '
          'device clock. Prayer times will be wrong for any location outside '
          'the device zone.');
      return null;
    }
    try {
      return tz.getLocation(timezone);
    } catch (error) {
      debugPrint('[PrayerTime] Unresolvable timezone "$timezone" ($error) — '
          'falling back to the device clock.');
      return null;
    }
  }

  /// Current moment at the prayer location.
  ///
  /// A `TZDateTime`, so its calendar fields read as that location's wall clock
  /// while its epoch stays a true instant — the two properties every caller
  /// here needs at once, and the reason nothing shifts a UTC value by hand any
  /// more.
  DateTime get nowInPrayerTimezone => _nowInPrayerTimezone();

  DateTime _nowInPrayerTimezone() {
    final location = this.location;
    if (location == null) return DateTime.now();
    return tz.TZDateTime.now(location);
  }

  /// Moves [date] by whole calendar days.
  ///
  /// Done on the date components rather than by adding 24 hours: on the day the
  /// clocks go back, 24 hours after 00:30 is 23:30 the same date, which would
  /// have this compute "tomorrow's" prayers for today.
  DateTime _shiftDays(DateTime date, int days) {
    return DateTime.utc(date.year, date.month, date.day)
        .add(Duration(days: days));
  }

  /// Expresses an instant at the prayer location.
  DateTime _inZone(DateTime instant) {
    final location = this.location;
    if (location == null) return instant.toLocal();
    return tz.TZDateTime.from(instant, location);
  }

  /// The day's six computed times, each already at the prayer location.
  ///
  /// `adhan`'s own `utcOffset` argument is deliberately not used. It applies a
  /// single offset to the whole day, which is off by an hour for every prayer
  /// after a DST changeover, and it returns UTC values with the offset added
  /// in — so the resulting `DateTime`s carry the right wall clock on the wrong
  /// epoch, and any comparison against a real instant (an alarm, a countdown)
  /// is out by the offset. Converting each instant separately is exact on both
  /// counts.
  _DayPrayerTimes _createPrayerTimes(DateTime date) {
    final times = PrayerTimes(
      coordinates,
      DateComponents(date.year, date.month, date.day),
      _adjustedParams(),
    );

    return _DayPrayerTimes(
      fajr: _inZone(times.fajr),
      sunrise: _inZone(times.sunrise),
      dhuhr: _inZone(times.dhuhr),
      asr: _inZone(times.asr),
      maghrib: _inZone(times.maghrib),
      isha: _inZone(times.isha),
    );
  }

  DateTime _sehriEndsAt(DateTime fajrTime) {
    return fajrTime.subtract(tenMins);
  }

  Map<String, _PrayerScheduleEntry> _buildDisplaySchedule(
    AppLocalizations locales,
    String currentLang,
    DateTime date,
  ) {
    final basePrayerTimes = _createPrayerTimes(date);
    final nextPrayerTimes = _createPrayerTimes(_shiftDays(date, 1));

    return {
      'tahajjud': _PrayerScheduleEntry(
        key: 'tahajjud',
        title: locales.tahajjudSehri,
        startDateTime: _sehriEndsAt(basePrayerTimes.fajr),
        endDateTime: _sehriEndsAt(basePrayerTimes.fajr),
      ),
      'fajr': _PrayerScheduleEntry(
        key: 'fajr',
        title: locales.fajr,
        startDateTime: basePrayerTimes.fajr,
        endDateTime: basePrayerTimes.sunrise.subtract(oneMin),
      ),
      'sunrise': _PrayerScheduleEntry(
        key: 'sunrise',
        title: locales.sunrise,
        startDateTime: basePrayerTimes.sunrise,
        endDateTime: basePrayerTimes.sunrise.add(fourteenMins),
      ),
      'ishraq': _PrayerScheduleEntry(
        key: 'ishraq',
        title: locales.ishraqChasht,
        startDateTime: basePrayerTimes.sunrise.add(fifteenMins),
        endDateTime: basePrayerTimes.dhuhr.subtract(oneMin),
      ),
      'midday': _PrayerScheduleEntry(
        key: 'midday',
        title: locales.midday,
        startDateTime: basePrayerTimes.dhuhr,
        endDateTime: basePrayerTimes.dhuhr.add(fourMins),
      ),
      'dhuhr': _PrayerScheduleEntry(
        key: 'dhuhr',
        title: locales.zuhrZawal,
        startDateTime: basePrayerTimes.dhuhr.add(fiveMins),
        endDateTime: basePrayerTimes.asr.subtract(oneMin),
      ),
      'asr': _PrayerScheduleEntry(
        key: 'asr',
        title: locales.asr,
        startDateTime: basePrayerTimes.asr,
        endDateTime: basePrayerTimes.maghrib.subtract(fourMins),
      ),
      'sunset': _PrayerScheduleEntry(
        key: 'sunset',
        title: locales.sunset,
        startDateTime: basePrayerTimes.maghrib.subtract(threeMins),
        endDateTime: basePrayerTimes.maghrib.subtract(oneMin),
      ),
      'maghrib': _PrayerScheduleEntry(
        key: 'maghrib',
        title: locales.maghribIftar,
        startDateTime: basePrayerTimes.maghrib,
        endDateTime: basePrayerTimes.isha.subtract(oneMin),
      ),
      'isha': _PrayerScheduleEntry(
        key: 'isha',
        title: locales.isha,
        startDateTime: basePrayerTimes.isha,
        endDateTime: _sehriEndsAt(nextPrayerTimes.fajr),
      ),
    };
  }

  Map<String, _PrayerScheduleEntry> _buildPrayerWindowsForDate(DateTime date) {
    final basePrayerTimes = _createPrayerTimes(date);
    final nextPrayerTimes = _createPrayerTimes(_shiftDays(date, 1));

    return {
      'fajr': _PrayerScheduleEntry(
        key: 'fajr',
        title: 'fajr',
        startDateTime: basePrayerTimes.fajr,
        endDateTime: basePrayerTimes.sunrise.subtract(oneMin),
      ),
      'sunrise': _PrayerScheduleEntry(
        key: 'sunrise',
        title: 'sunrise',
        startDateTime: basePrayerTimes.sunrise,
        endDateTime: basePrayerTimes.sunrise.add(fourteenMins),
      ),
      'ishraq': _PrayerScheduleEntry(
        key: 'ishraq',
        title: 'ishraq',
        startDateTime: basePrayerTimes.sunrise.add(fifteenMins),
        endDateTime: basePrayerTimes.dhuhr.subtract(oneMin),
      ),
      'midday': _PrayerScheduleEntry(
        key: 'midday',
        title: 'midday',
        startDateTime: basePrayerTimes.dhuhr,
        endDateTime: basePrayerTimes.dhuhr.add(fourMins),
      ),
      'dhuhr': _PrayerScheduleEntry(
        key: 'dhuhr',
        title: 'dhuhr',
        startDateTime: basePrayerTimes.dhuhr.add(fiveMins),
        endDateTime: basePrayerTimes.asr.subtract(oneMin),
      ),
      'asr': _PrayerScheduleEntry(
        key: 'asr',
        title: 'asr',
        startDateTime: basePrayerTimes.asr,
        endDateTime: basePrayerTimes.maghrib.subtract(fourMins),
      ),
      'sunset': _PrayerScheduleEntry(
        key: 'sunset',
        title: 'sunset',
        startDateTime: basePrayerTimes.maghrib.subtract(threeMins),
        endDateTime: basePrayerTimes.maghrib.subtract(oneMin),
      ),
      'maghrib': _PrayerScheduleEntry(
        key: 'maghrib',
        title: 'maghrib',
        startDateTime: basePrayerTimes.maghrib,
        endDateTime: basePrayerTimes.isha.subtract(oneMin),
      ),
      'isha': _PrayerScheduleEntry(
        key: 'isha',
        title: 'isha',
        startDateTime: basePrayerTimes.isha,
        endDateTime: _sehriEndsAt(nextPrayerTimes.fajr),
      ),
    };
  }

  _PrayerScheduleEntry? _currentPrayerWindow(DateTime now) {
    final previousDayWindows = _buildPrayerWindowsForDate(_shiftDays(now, -1));
    final currentDayWindows = _buildPrayerWindowsForDate(now);

    final windows = [
      previousDayWindows['isha']!,
      currentDayWindows['fajr']!,
      currentDayWindows['sunrise']!,
      currentDayWindows['ishraq']!,
      currentDayWindows['midday']!,
      currentDayWindows['dhuhr']!,
      currentDayWindows['asr']!,
      currentDayWindows['sunset']!,
      currentDayWindows['maghrib']!,
      currentDayWindows['isha']!,
    ];

    for (final window in windows) {
      final startsNow = now.isAtSameMomentAs(window.startDateTime);
      final afterStart = now.isAfter(window.startDateTime);
      final beforeEnd = now.isBefore(window.endDateTime);
      if ((startsNow || afterStart) && beforeEnd) {
        return window;
      }
    }

    return null;
  }

  _PrayerScheduleEntry? _nextPrayerWindow(DateTime now) {
    final currentDayWindows = _buildPrayerWindowsForDate(now);
    final nextDayWindows = _buildPrayerWindowsForDate(_shiftDays(now, 1));

    final windows = [
      currentDayWindows['fajr']!,
      currentDayWindows['sunrise']!,
      currentDayWindows['ishraq']!,
      currentDayWindows['midday']!,
      currentDayWindows['dhuhr']!,
      currentDayWindows['asr']!,
      currentDayWindows['sunset']!,
      currentDayWindows['maghrib']!,
      currentDayWindows['isha']!,
      nextDayWindows['fajr']!,
    ];

    for (final window in windows) {
      if (window.startDateTime.isAfter(now)) {
        return window;
      }
    }

    return nextDayWindows['fajr'];
  }

  String _localizedPrayerTitle(String prayerKey, AppLocalizations locales) {
    switch (prayerKey) {
      case 'fajr':
        return locales.fajr;
      case 'sunrise':
        return locales.sunrise;
      case 'ishraq':
        return locales.ishraqChasht;
      case 'dhuhr':
        return locales.zuhrZawal;
      case 'asr':
        return locales.asr;
      case 'midday':
        return locales.midday;
      case 'sunset':
        return locales.sunset;
      case 'maghrib':
        return locales.maghribIftar;
      case 'isha':
        return locales.isha;
      default:
        return prayerKey;
    }
  }

  String _formatTime(DateTime time, String locale) {
    return DateFormat('h:mm', locale).format(time);
  }

  CalculationParameters _adjustedParams() {
    final method = preferences.getString('method') ?? 'Karachi';
    final madhab = preferences.getString('madhab') ?? 'hanafi';
    final params = _calculationMethod(method);
    params.madhab = _getMadhab(madhab);
    params.adjustments.fajr = preferences.getInt('fajr') ?? 5;
    params.adjustments.sunrise = preferences.getInt('sunrise') ?? 0;
    params.adjustments.dhuhr = preferences.getInt('dhuhr') ?? 0;
    params.adjustments.asr = preferences.getInt('asr') ?? 0;
    params.adjustments.maghrib = preferences.getInt('maghrib') ?? 3;
    params.adjustments.isha = preferences.getInt('isha') ?? 0;
    return params;
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

  Madhab _getMadhab(String madhab) {
    switch (madhab) {
      case 'hanafi':
        return Madhab.hanafi;
      case 'shafi':
        return Madhab.shafi;
      default:
        return Madhab.hanafi;
    }
  }
}

/// The six times `adhan` computes for one day, each expressed at the prayer
/// location.
class _DayPrayerTimes {
  const _DayPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
}

class _PrayerScheduleEntry {
  const _PrayerScheduleEntry({
    required this.key,
    required this.title,
    required this.startDateTime,
    required this.endDateTime,
  });

  final String key;
  final String title;
  final DateTime startDateTime;
  final DateTime endDateTime;

  Map<String, dynamic> toMap(
    String locale,
    String Function(DateTime time, String locale) formatter,
  ) {
    return {
      'title': title,
      'startTime': formatter(startDateTime, locale),
      'endTime': formatter(endDateTime, locale),
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
    };
  }
}

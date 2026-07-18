import 'dart:core';

import 'package:adhan/adhan.dart';
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
    referenceDate = currentDate ?? _nowInPrayerTimezone();
    prayerTimes = _createPrayerTimes(referenceDate);
    nextDayPrayerTimes = _createPrayerTimes(
      referenceDate.add(const Duration(days: 1)),
    );
  }

  final Coordinates coordinates;
  final String timezone;
  final SharedPreferences preferences;
  final DateTime? currentDate;

  late final DateTime referenceDate;
  late final PrayerTimes prayerTimes;
  late final PrayerTimes nextDayPrayerTimes;

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
        },
      },
      'next': {
        'title': nextWindow != null
            ? _localizedPrayerTitle(nextWindow.key, locales)
            : todaySchedule['fajr']!.title,
        'time': nextWindow != null
            ? _formatTime(nextWindow.startDateTime, currentLang)
            : _formatTime(todaySchedule['fajr']!.startDateTime, currentLang),
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
    return prayerTimes.maghrib;
  }

  DateTime? getPrayerStartDateTime(
    String prayerKey, {
    DateTime? date,
  }) {
    final windows = _buildPrayerWindowsForDate(date ?? referenceDate);
    return windows[prayerKey]?.startDateTime;
  }

  /// Returns the DST-aware UTC offset for [forDate] in the stored timezone.
  Duration? _utcOffsetFor(DateTime forDate) {
    if (timezone.isEmpty) return null;
    try {
      final location = tz.getLocation(timezone);
      final tzDate = tz.TZDateTime(
        location,
        forDate.year,
        forDate.month,
        forDate.day,
      );
      return tzDate.timeZoneOffset;
    } catch (_) {
      return null;
    }
  }

  /// Current moment expressed in the prayer location's timezone,
  /// as a "shifted UTC" DateTime matching the format adhan returns.
  /// Use this when computing time-remaining against adhan DateTimes.
  DateTime get nowInPrayerTimezone => _nowInPrayerTimezone();

  DateTime _nowInPrayerTimezone() {
    final now = DateTime.now();
    final utcOffset = _utcOffsetFor(now);
    if (utcOffset == null) return now;
    return now.toUtc().add(utcOffset);
  }

  PrayerTimes _createPrayerTimes(DateTime date) {
    return PrayerTimes(
      coordinates,
      DateComponents(date.year, date.month, date.day),
      _adjustedParams(),
      utcOffset: _utcOffsetFor(date),
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
    final previousPrayerTimes =
        _createPrayerTimes(date.subtract(const Duration(days: 1)));
    final basePrayerTimes = _createPrayerTimes(date);
    final nextPrayerTimes =
        _createPrayerTimes(date.add(const Duration(days: 1)));

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
    final nextPrayerTimes =
        _createPrayerTimes(date.add(const Duration(days: 1)));

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
    final previousDayWindows = _buildPrayerWindowsForDate(
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)),
    );
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
    final nextDayWindows = _buildPrayerWindowsForDate(
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
    );

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

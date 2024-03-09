import 'package:adhan/adhan.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTime {
  PrayerTime({
    required this.coordinates,
    required this.preferences,
    this.currentDate,
  }) {
    DateTime today = currentDate ?? DateTime.now();
    prayerTimes = PrayerTimes(
      coordinates,
      DateComponents(today.year, today.month, today.day),
      _adjustedParams(),
    );
  }

  final Coordinates coordinates;
  final SharedPreferences preferences;
  final DateTime? currentDate;
  late final PrayerTimes prayerTimes;
  final Duration oneMin = const Duration(minutes: 1);
  final Duration threeMins = const Duration(minutes: 3);
  final Duration fourMins = const Duration(minutes: 4);
  final Duration fiveMins = const Duration(minutes: 5);
  final Duration tenMins = const Duration(minutes: 10);
  final Duration fourteenMins = const Duration(minutes: 14);
  final Duration fifteenMins = const Duration(minutes: 15);

  Map getTimes(AppLocalizations locales, String currentLang) {
    return {
      'tahajjud': {
        'title': locales.tahajjudSehri,
        'endTime': _formatTime(prayerTimes.fajr.subtract(tenMins), currentLang),
      },
      'fajr': {
        'title': locales.fajr,
        'startTime': _formatTime(prayerTimes.fajr, currentLang),
        'endTime': _formatTime(
          prayerTimes.sunrise.subtract(oneMin),
          currentLang,
        ),
      },
      'sunrise': {
        'title': locales.sunrise,
        'startTime': _formatTime(prayerTimes.sunrise, currentLang),
        'endTime': _formatTime(
          prayerTimes.sunrise.add(fourteenMins),
          currentLang,
        ),
      },
      'ishraq': {
        'title': locales.ishraqChasht,
        'startTime': _formatTime(
          prayerTimes.sunrise.add(fifteenMins),
          currentLang,
        ),
        'endTime': _formatTime(prayerTimes.dhuhr.subtract(oneMin), currentLang),
      },
      'midday': {
        'title': locales.midday,
        'startTime': _formatTime(prayerTimes.dhuhr, currentLang),
        'endTime': _formatTime(prayerTimes.dhuhr.add(fourMins), currentLang),
      },
      'dhuhr': {
        'title': locales.zuhrZawal,
        'startTime': _formatTime(prayerTimes.dhuhr.add(fiveMins), currentLang),
        'endTime': _formatTime(prayerTimes.asr.subtract(oneMin), currentLang),
      },
      'asr': {
        'title': locales.asr,
        'startTime': _formatTime(prayerTimes.asr, currentLang),
        'endTime': _formatTime(
          prayerTimes.maghrib.subtract(fourMins),
          currentLang,
        ),
      },
      'sunset': {
        'title': locales.sunset,
        'startTime': _formatTime(
          prayerTimes.maghrib.subtract(threeMins),
          currentLang,
        ),
        'endTime': _formatTime(
          prayerTimes.maghrib.subtract(oneMin),
          currentLang,
        ),
      },
      'maghrib': {
        'title': locales.maghribIftar,
        'startTime': _formatTime(
          prayerTimes.maghrib,
          currentLang,
        ),
        'endTime': _formatTime(prayerTimes.isha.subtract(oneMin), currentLang),
        'startDateTime': prayerTimes.maghrib,
      },
      'isha': {
        'title': locales.isha,
        'startTime': _formatTime(prayerTimes.isha, currentLang),
        'endTime': _formatTime(prayerTimes.fajr.subtract(tenMins), currentLang),
      },
    };
  }

  Map getSunriseSunset(AppLocalizations locales, String currentLang) {
    return {
      'sunrise': {
        'title': locales.sunrise,
        'time': _formatTime(prayerTimes.sunrise, currentLang),
      },
      'sunset': {
        'title': locales.sunset,
        'time': _formatTime(
          prayerTimes.maghrib.subtract(threeMins),
          currentLang,
        ),
      },
    };
  }

  Map getCurrentAndNextPrayers(AppLocalizations locales, String currentLang) {
    Map times = getTimes(locales, currentLang);
    Map prayers = currentAndNextPrayerNames();
    var currentPrayer = prayers['currentPrayer'];
    var nextPrayer = prayers['nextPrayer'];

    return {
      if (currentPrayer != 'none') ...{
        'current': {
          'title': times[currentPrayer]['title'],
          'time':
              '${times[currentPrayer]['startTime']} - ${times[currentPrayer]['endTime']}',
        },
      } else
        ...{},
      'next': {
        'title': times[nextPrayer]['title'],
        'time': times[nextPrayer]['startTime'],
      },
    };
  }

  DateTime getDateStartTime() {
    return prayerTimes.maghrib;
  }

  String _formatTime(DateTime time, String locale) {
    return DateFormat.jm(locale).format(time);
  }

  CalculationParameters _adjustedParams() {
    String method = preferences.getString('method') ?? 'Karachi';
    String madhab = preferences.getString('madhab') ?? 'hanafi';
    CalculationParameters params = _calculationMethod(method);
    params.madhab = _getMadhab(madhab);
    params.adjustments.fajr = preferences.getInt('fajr') ?? 5;
    params.adjustments.sunrise = preferences.getInt('sunrise') ?? 0;
    params.adjustments.dhuhr = preferences.getInt('dhuhr') ?? 0;
    params.adjustments.asr = preferences.getInt('asr') ?? 0;
    params.adjustments.maghrib = preferences.getInt('maghrib') ?? 3;
    params.adjustments.isha = preferences.getInt('isha') ?? 0;

    return params;
  }

  Map<String, String> currentAndNextPrayerNames() {
    DateTime currentTime = DateTime.now();

    String currentPrayer =
        prayerTimes.currentPrayer().toString().split('.').last;
    String nextPrayer = prayerTimes.nextPrayer().toString().split('.').last;

    DateTime ishraqStartTime = prayerTimes.sunrise.add(fifteenMins);
    DateTime ishraqEndTime = prayerTimes.dhuhr.subtract(oneMin);
    DateTime dhuhrStartTime = prayerTimes.dhuhr.add(fiveMins);
    DateTime asrEndTime = prayerTimes.maghrib.subtract(fourMins);
    DateTime ishaEndTime = prayerTimes.fajr.subtract(tenMins);

    if (currentPrayer == 'none') {
      currentPrayer = 'isha';
    }

    if (currentPrayer == 'sunrise') {
      if ((currentTime.isAtSameMomentAs(ishraqStartTime) ||
              currentTime.isAfter(ishraqStartTime)) &&
          currentTime.isBefore(ishraqEndTime)) {
        currentPrayer = 'ishraq';
      } else {
        currentPrayer = 'none';
      }
    }

    if (currentPrayer == 'dhuhr' && currentTime.isBefore(dhuhrStartTime)) {
      currentPrayer = 'none';
      nextPrayer = 'dhuhr';
    }

    if (currentPrayer == 'asr' && currentTime.isAfter(asrEndTime)) {
      currentPrayer = 'none';
    }

    if (currentPrayer == 'isha' &&
        currentTime.isAfter(ishaEndTime) &&
        currentTime.isBefore(prayerTimes.fajr)) {
      currentPrayer = 'none';
    }

    if (nextPrayer == 'none') {
      nextPrayer = 'fajr';
    }

    if (['dhuhr', 'sunrise'].contains(nextPrayer) &&
        currentTime.isBefore(ishraqStartTime)) {
      nextPrayer = 'ishraq';
    }

    return {
      'currentPrayer': currentPrayer,
      'nextPrayer': nextPrayer,
    };
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

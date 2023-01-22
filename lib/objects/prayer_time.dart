import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerTime {
  PrayerTime({
    required this.coordinates,
    required this.preferences,
  }) {
    prayerTimes = PrayerTimes.today(
      coordinates,
      _adjustedParams(),
    );
  }

  final Coordinates coordinates;
  final SharedPreferences preferences;
  late final PrayerTimes prayerTimes;
  final Duration oneMin = const Duration(minutes: 1);
  final Duration threeMins = const Duration(minutes: 3);
  final Duration fourMins = const Duration(minutes: 4);
  final Duration fiveMins = const Duration(minutes: 5);
  final Duration tenMins = const Duration(minutes: 10);
  final Duration fifteenMins = const Duration(minutes: 15);

  Map getTimes() {
    return {
      'tahajjud': {
        'title': 'Tahajjud, Sehri Ends',
        'endTime': _formatTime(prayerTimes.fajr.subtract(tenMins)),
      },
      'fajr': {
        'title': 'Fajr',
        'startTime': _formatTime(prayerTimes.fajr),
        'endTime': _formatTime(prayerTimes.sunrise.subtract(oneMin)),
      },
      'sunrise': {
        'title': 'Sunrise',
        'time': _formatTime(prayerTimes.sunrise),
      },
      'ishraq': {
        'title': 'Ishraq, Chasht',
        'startTime': _formatTime(prayerTimes.sunrise.add(fifteenMins)),
        'endTime': _formatTime(prayerTimes.dhuhr.subtract(oneMin)),
      },
      'midday': {
        'title': 'Midday',
        'time': _formatTime(prayerTimes.dhuhr),
      },
      'dhuhr': {
        'title': 'Zuhr, Zawal',
        'startTime': _formatTime(prayerTimes.dhuhr.add(fiveMins)),
        'endTime': _formatTime(prayerTimes.asr.subtract(oneMin)),
      },
      'asr': {
        'title': 'Asr',
        'startTime': _formatTime(prayerTimes.asr),
        'endTime': _formatTime(prayerTimes.maghrib.subtract(fourMins)),
      },
      'sunset': {
        'title': 'Sunset',
        'time': _formatTime(prayerTimes.maghrib.subtract(threeMins)),
      },
      'maghrib': {
        'title': 'Maghrib, Iftar',
        'startTime': _formatTime(prayerTimes.maghrib),
        'endTime': _formatTime(prayerTimes.isha.subtract(oneMin)),
      },
      'isha': {
        'title': 'Isha',
        'startTime': _formatTime(prayerTimes.isha),
        'endTime': _formatTime(prayerTimes.fajr.subtract(tenMins)),
      }
    };
  }

  Map getCurrentAndNextPrayers() {
    Map times = getTimes();
    Map prayers = _currentAndNextPrayerNames();
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

  String _formatTime(DateTime time) {
    return DateFormat.jm().format(time);
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

  Map<String, String> _currentAndNextPrayerNames() {
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
      case 'Tehran':
        return CalculationMethod.tehran.getParameters();
      case 'NorthAmerica':
        return CalculationMethod.north_america.getParameters();
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

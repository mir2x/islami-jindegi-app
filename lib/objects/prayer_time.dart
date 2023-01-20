import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTime {
  PrayerTime({
    required this.coordinates,
    required this.preferences,
  });

  final dynamic coordinates;
  final dynamic preferences;

  getPrayerTimes() {
    return PrayerTimes.today(
      coordinates,
      _adjustedParams(),
    );
  }

  Map getTimes() {
    final prayerTimes = getPrayerTimes();

    Duration oneMin = const Duration(minutes: 1);
    Duration threeMins = const Duration(minutes: 3);
    Duration fourMins = const Duration(minutes: 4);
    Duration fiveMins = const Duration(minutes: 5);
    Duration tenMins = const Duration(minutes: 10);
    Duration fifteenMins = const Duration(minutes: 15);

    return {
      'tahajjud': {
        'title': 'Tahajjud, Sehri Ends',
        'endTime': formatTime(prayerTimes.fajr.subtract(tenMins)),
      },
      'fajr': {
        'title': 'Fajr',
        'startTime': formatTime(prayerTimes.fajr),
        'endTime': formatTime(prayerTimes.sunrise.subtract(oneMin)),
      },
      'sunrise': {
        'title': 'Sunrise',
        'time': formatTime(prayerTimes.sunrise),
      },
      'ishraq': {
        'title': 'Ishraq, Chasht',
        'startTime': formatTime(prayerTimes.sunrise.add(fifteenMins)),
        'endTime': formatTime(prayerTimes.dhuhr.subtract(oneMin)),
      },
      'midday': {
        'title': 'Midday',
        'time': formatTime(prayerTimes.dhuhr),
      },
      'dhuhr': {
        'title': 'Zuhr, Zawal',
        'startTime': formatTime(prayerTimes.dhuhr.add(fiveMins)),
        'endTime': formatTime(prayerTimes.asr.subtract(oneMin)),
      },
      'asr': {
        'title': 'Asr',
        'startTime': formatTime(prayerTimes.asr),
        'endTime': formatTime(prayerTimes.maghrib.subtract(fourMins)),
      },
      'sunset': {
        'title': 'Sunset',
        'time': formatTime(prayerTimes.maghrib.subtract(threeMins)),
      },
      'maghrib': {
        'title': 'Maghrib, Iftar',
        'startTime': formatTime(prayerTimes.maghrib),
        'endTime': formatTime(prayerTimes.isha.subtract(oneMin)),
      },
      'isha': {
        'title': 'Isha',
        'startTime': formatTime(prayerTimes.isha),
        'endTime': formatTime(prayerTimes.fajr.subtract(tenMins)),
      }
    };
  }

  Map getCurrentAndNextPrayers() {
    var times = getTimes();
    var prayers = _currentAndNextPrayerNames();
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

  String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  dynamic _adjustedParams() {
    String method = preferences.getString('method') ?? 'Karachi';
    String madhab = preferences.getString('madhab') ?? 'hanafi';
    var params = _calculationMethod(method);
    params.madhab = _getMadhab(madhab);
    params.adjustments.fajr = preferences.getInt('fajr') ?? 5;
    params.adjustments.sunrise = preferences.getInt('sunrise') ?? 0;
    params.adjustments.dhuhr = preferences.getInt('dhuhr') ?? 0;
    params.adjustments.asr = preferences.getInt('asr') ?? 0;
    params.adjustments.maghrib = preferences.getInt('maghrib') ?? 3;
    params.adjustments.isha = preferences.getInt('isha') ?? 0;

    return params;
  }

  dynamic _calculationMethod(String method) {
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
    }
  }

  dynamic _getMadhab(String madhab) {
    switch (madhab) {
      case 'hanafi':
        return Madhab.hanafi;
      case 'shafi':
        return Madhab.shafi;
    }
  }

  Map _currentAndNextPrayerNames() {
    final prayerTimes = getPrayerTimes();
    final currentTime = DateTime.now();

    var currentPrayer = prayerTimes.currentPrayer().toString().split('.').last;
    var nextPrayer = prayerTimes.nextPrayer().toString().split('.').last;

    Duration oneMin = const Duration(minutes: 1);
    Duration fourMins = const Duration(minutes: 4);
    Duration fiveMins = const Duration(minutes: 5);
    Duration tenMins = const Duration(minutes: 10);
    Duration fifteenMins = const Duration(minutes: 15);

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
}

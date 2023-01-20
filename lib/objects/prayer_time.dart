import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

class PrayerTime {
  PrayerTime({
    required this.coordinates,
    required this.preferences,
  });

  final dynamic coordinates;
  final dynamic preferences;

  Map getTimes() {
    final prayerTimes = PrayerTimes.today(
      coordinates,
      _adjustedParams(),
    );

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
}

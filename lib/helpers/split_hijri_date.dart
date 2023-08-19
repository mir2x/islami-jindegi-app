import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

Map splitHijriDate(HijriCalendar date, locales, String currentLang) {
  final Map months = {
    '1': locales.muharrom,
    '2': locales.safar,
    '3': locales.rabiulAowal,
    '4': locales.rabiusSani,
    '5': locales.jamadalUla,
    '6': locales.jamadalUkhra,
    '7': locales.rajab,
    '8': locales.shaban,
    '9': locales.ramajan,
    '10': locales.shauwal,
    '11': locales.jilqod,
    '12': locales.jilhajj,
  };

  var numFormatter = NumberFormat('#', currentLang);
  var day = numFormatter.format(date.hDay);
  String month = months[date.hMonth.toString()];
  var year = numFormatter.format(date.hYear);

  return {
    'day': day,
    'month': month,
    'year': year,
  };
}

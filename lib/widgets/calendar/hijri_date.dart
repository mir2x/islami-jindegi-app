import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class HijriDate extends StatelessWidget {
  const HijriDate({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;

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

    dynamic today = HijriCalendar.now();
    var numFormatter = NumberFormat('#', currentLang);
    var day = numFormatter.format(today.hDay);
    String month = months[today.hMonth.toString()];
    var year = numFormatter.format(today.hYear);

    return Text('$day $month, $year ${locales.hijri}');
  }
}

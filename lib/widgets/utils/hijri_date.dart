import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriDate extends StatelessWidget {
  HijriDate({super.key});

  final Map months = {
    '1': 'Muharrom',
    '2': 'Safar',
    '3': 'Rabiul Aowal',
    '4': 'Rabius Sani',
    '5': 'Jumadal Ula',
    '6': 'Jumadal Ukhra',
    '7': 'Rajab',
    '8': 'Shaban',
    '9': 'Ramajan',
    '10': 'Shauwal',
    '11': 'Jilqod',
    '12': 'Jilhajj',
  };

  @override
  Widget build(BuildContext context) {
    dynamic today = HijriCalendar.now();
    String month = months[today.hMonth.toString()];

    return Text('${today.hDay} $month, ${today.hYear} Hijri');
  }
}

import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriCalendarBuilders {
  const HijriCalendarBuilders({
    this.weekdayBuilder,
    this.dayBuilder,
    this.monthYearBuilder,
  });

  /// Weekdays builder (day: Sun, Mon.., number: 0, 1..)
  final Widget Function(
      BuildContext context, String day, int number)? weekdayBuilder;

  /// Days builder (1, 2, ..)
  final Widget Function(
      BuildContext context, HijriCalendar day, bool isSelected)? dayBuilder;

  /// Month/year header builder (month: 1-12, year: e.g. 1447)
  final Widget Function(
      BuildContext context, int month, int year)? monthYearBuilder;
}

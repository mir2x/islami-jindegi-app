import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/widgets/calendar/gregorian_date.dart';
import 'hijri_date_calendar.dart';
import 'gregorian_date_calendar.dart';

class CalendarDates extends StatefulWidget {
  const CalendarDates({
    super.key,
    required this.selectedHijriDate,
    required this.selectedGregorianDate,
    required this.updateHijriDate,
    required this.updateGregorianDate,
  });

  final HijriCalendar? selectedHijriDate;
  final DateTime? selectedGregorianDate;
  final Function updateHijriDate;
  final Function updateGregorianDate;

  @override
  CalendarDatesState createState() => CalendarDatesState();
}

class CalendarDatesState extends State<CalendarDates> {
  Timer? timer;
  int count = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) => setState(() {
        count += 1;
      }),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HijriDateCalendar(
          currentDate: widget.selectedHijriDate,
          onUpdate: widget.updateHijriDate,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HijriDate(currentDate: widget.selectedHijriDate, count: count),
              const SizedBox(width: 15),
              const Icon(Icons.calendar_month),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GregorianDateCalendar(
          currentDate: widget.selectedGregorianDate,
          onUpdate: widget.updateGregorianDate,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GregorianDate(
                currentDate: widget.selectedGregorianDate,
                count: count,
              ),
              const SizedBox(width: 10),
              const Icon(Icons.calendar_month),
            ],
          ),
        ),
      ],
    );
  }
}

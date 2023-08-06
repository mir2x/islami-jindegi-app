import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/widgets/calendar/gregorian_date.dart';
import 'hijri_date_calendar.dart';

class CalendarDates extends StatefulWidget {
  const CalendarDates({
    super.key,
    required this.selectedHijriDate,
    required this.currentGregorianDate,
    required this.updateHijriDate,
  });

  final HijriCalendar? selectedHijriDate;
  final DateTime? currentGregorianDate;
  final Function updateHijriDate;

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
        Container(
          margin: const EdgeInsets.only(top: 5),
          child: GregorianDate(
            currentDate: widget.currentGregorianDate,
            count: count,
          ),
        ),
      ],
    );
  }
}

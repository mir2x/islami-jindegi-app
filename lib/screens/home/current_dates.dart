import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/calendar/hijri_date.dart';
import 'package:native_app/widgets/calendar/bangali_date.dart';
import 'package:native_app/widgets/calendar/gregorian_date.dart';

class CurrentDates extends ConsumerStatefulWidget {
  const CurrentDates({super.key});

  @override
  CurrentDatesState createState() => CurrentDatesState();
}

class CurrentDatesState extends ConsumerState<CurrentDates> {
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HijriDate(count: count),
        if (!isMobile) ...[const SizedBox(height: 5)],
        BangaliDate(count: count),
        if (!isMobile) ...[const SizedBox(height: 5)],
        GregorianDate(count: count),
      ],
    );
  }
}

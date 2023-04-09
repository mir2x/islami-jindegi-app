import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/theme/colors.dart';

class HijriDateCalendar extends ConsumerWidget {
  const HijriDateCalendar({
    super.key,
    required this.child,
    required this.onUpdate,
  });

  final Widget child;
  final Function onUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: ThemeColors.color1,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: HijriMonthPicker(
                  selectedDate: HijriCalendar.now(),
                  firstDate: HijriCalendar()
                    ..hYear = 1400
                    ..hMonth = 1
                    ..hDay = 1,
                  lastDate: HijriCalendar()
                    ..hYear = 1500
                    ..hMonth = 1
                    ..hDay = 1,
                  onChanged: (HijriCalendar value) {
                    onUpdate(value);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
        );
      },
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/preferences.dart';

class HijriDateCalendar extends ConsumerWidget {
  const HijriDateCalendar({
    super.key,
    required this.child,
    required this.onUpdate,
    this.currentDate,
  });

  final Widget child;
  final Function onUpdate;
  final HijriCalendar? currentDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var preferences = ref.watch(preferencesProvider);

    return preferences.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
      data: (prefs) {
        return GestureDetector(
          onTap: () {
            HijriCalendar today;

            if (currentDate != null) {
              today = currentDate!;
            } else {
              int adjustment = prefs.getInt('hijriAdjustment') ?? 0;
              final DateTime date = DateTime.now();
              DateTime adjustedToday =
                  DateTime(date.year, date.month, date.day + adjustment);

              today = HijriCalendar.fromDate(adjustedToday);
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: HijriMonthPicker(
                      selectedDate: today,
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
      },
    );
  }
}

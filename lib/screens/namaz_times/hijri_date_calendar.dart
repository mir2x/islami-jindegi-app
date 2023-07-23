import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';

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
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return settingsProvider.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
      data: (settings) {
        return GestureDetector(
          onTap: () {
            HijriCalendar today;
            int adjustedWeekdayNumber = 0;
            int localAdjustment =
                settings['preferences'].getInt('hijriAdjustment') ?? 0;

            if (currentDate != null) {
              today = currentDate!;
              adjustedWeekdayNumber -= localAdjustment;
            } else {
              today = adjustedHijriDate(settings);

              if (isAfterDateStartTime(DateTime.now(), settings)) {
                adjustedWeekdayNumber -= 1;
              }

              if (localAdjustment != 0) {
                adjustedWeekdayNumber -= localAdjustment;
              } else {
                int adminAdjustment = settings['adminHijriAdjustment'];
                adjustedWeekdayNumber -= adminAdjustment;
              }
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: HijriMonthPicker(
                      builders: HijriCalendarBuilders(
                        weekdayBuilder: (context, day, number) {
                          MaterialLocalizations localizations =
                              MaterialLocalizations.of(context);
                          int num = (number + adjustedWeekdayNumber) % 7;
                          final String weekday =
                              localizations.narrowWeekdays[num];

                          return Center(
                            child: Text(weekday),
                          );
                        },
                      ),
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

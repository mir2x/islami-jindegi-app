import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/widgets/calendar/bd_hijri_month_picker.dart';

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
        return InkWell(
          onTap: () {
            final HijriCalendar bdToday = adjustedHijriDate(settings);
            final HijriCalendar selected = currentDate ?? bdToday;

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: BdHijriMonthPicker(
                      settings: settings,
                      selectedDate: selected,
                      firstDate: HijriCalendar()
                        ..hYear = 1400
                        ..hMonth = 1
                        ..hDay = 1,
                      lastDate: HijriCalendar()
                        ..hYear = 1500
                        ..hMonth = 1
                        ..hDay = 1,
                      onChanged: (HijriCalendar value, DateTime gregorian) {
                        onUpdate(value, gregorian);
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/geolocation.dart';
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
    var dataP = ref.watch(preferencesAndGeolocationProvider);

    return dataP.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
      data: (data) {
        return GestureDetector(
          onTap: () {
            HijriCalendar today;

            if (currentDate != null) {
              today = currentDate!;
            } else {
              today = adjustedHijriDate(data);
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_picker/hijri_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/hijri_localization.dart';

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
            final HijriCalendar pickerSelected =
                displayHijriToPickerHijri(settings, selected);
            final String lang =
                Localizations.localeOf(context).languageCode;
            final int shift = hijriWeekdayShift(settings);

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: HijriMonthPicker(
                      builders: HijriCalendarBuilders(
                        weekdayBuilder: (context, day, number) {
                          final int idx = (number + shift) % 7;
                          final String label = lang == 'bn'
                              ? weekdaysBengaliShort[idx]
                              : _englishShortWeekdays[idx];
                          return Center(child: Text(label));
                        },
                        monthYearBuilder: (context, month, year) {
                          final displayMonth = pickerHijriToDisplayHijri(
                            settings,
                            HijriCalendar()
                              ..hYear = year
                              ..hMonth = month
                              ..hDay = 15,
                          );
                          final String adjustedLabel = lang == 'bn'
                              ? hijriMonthYearBengali(
                                  displayMonth.hMonth,
                                  displayMonth.hYear,
                                )
                              : hijriMonthYearEnglish(
                                  displayMonth.hMonth,
                                  displayMonth.hYear,
                                );
                          return Text(
                            adjustedLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        },
                        dayBuilder: (context, hijriDay, isSelected) {
                          final th = Theme.of(context);
                          final loc = MaterialLocalizations.of(context);
                          final displayDay =
                              pickerHijriToDisplayHijri(settings, hijriDay);
                          final isToday = displayDay.hYear == bdToday.hYear &&
                              displayDay.hMonth == bdToday.hMonth &&
                              displayDay.hDay == bdToday.hDay;
                          BoxDecoration? deco;
                          TextStyle? style = th.textTheme.bodyMedium;
                          if (isSelected) {
                            style = th.textTheme.bodyLarge
                                ?.copyWith(color: th.colorScheme.onSecondary);
                            deco = BoxDecoration(
                                color: th.colorScheme.secondary,
                                shape: BoxShape.circle,);
                          } else if (isToday) {
                            style = th.textTheme.bodyLarge
                                ?.copyWith(color: th.colorScheme.secondary);
                          }
                          return Container(
                            decoration: deco,
                            child: Center(
                              child: Text(
                                loc.formatDecimal(displayDay.hDay),
                                style: style,
                              ),
                            ),
                          );
                        },
                      ),
                      selectedDate: pickerSelected,
                      firstDate: HijriCalendar()
                        ..hYear = 1400
                        ..hMonth = 1
                        ..hDay = 1,
                      lastDate: HijriCalendar()
                        ..hYear = 1500
                        ..hMonth = 1
                        ..hDay = 1,
                      onChanged: (HijriCalendar value) {
                        onUpdate(pickerHijriToDisplayHijri(settings, value));
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

const List<String> _englishShortWeekdays = [
  'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
];

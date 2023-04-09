import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:native_app/providers/preferences.dart';

class HijriDate extends ConsumerWidget {
  const HijriDate({
    super.key,
    this.currentDate,
  });

  final HijriCalendar? currentDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var preferences = ref.watch(preferencesProvider);

    return preferences.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
      data: (prefs) {
        final Map months = {
          '1': locales.muharrom,
          '2': locales.safar,
          '3': locales.rabiulAowal,
          '4': locales.rabiusSani,
          '5': locales.jamadalUla,
          '6': locales.jamadalUkhra,
          '7': locales.rajab,
          '8': locales.shaban,
          '9': locales.ramajan,
          '10': locales.shauwal,
          '11': locales.jilqod,
          '12': locales.jilhajj,
        };

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

        var numFormatter = NumberFormat('#', currentLang);
        var day = numFormatter.format(today.hDay);
        String month = months[today.hMonth.toString()];
        var year = numFormatter.format(today.hYear);

        return Text('$day $month, $year ${locales.hijri}');
      },
    );
  }
}

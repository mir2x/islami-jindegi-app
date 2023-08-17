import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class HijriDate extends ConsumerWidget {
  const HijriDate({
    super.key,
    this.currentDate,
    this.count,
  });

  final HijriCalendar? currentDate;
  final int? count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return settingsProvider.when(
      loading: () => Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: const SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, _) => Text(error.toString()),
      data: (Map settings) {
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
          today = adjustedHijriDate(settings);
        }

        var numFormatter = NumberFormat('#', currentLang);
        var day = numFormatter.format(today.hDay);
        String month = months[today.hMonth.toString()];
        var year = numFormatter.format(today.hYear);
        String hijriDate = '$day $month, $year ${locales.hijri}';

        updateAppWidget({'hijriDate': hijriDate});

        return Text(hijriDate);
      },
    );
  }
}

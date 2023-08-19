import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/split_hijri_date.dart';

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
        HijriCalendar today;

        if (currentDate != null) {
          today = currentDate!;
        } else {
          today = adjustedHijriDate(settings);
        }

        Map h = splitHijriDate(today, locales, currentLang);
        String hijriDate =
            '${h['day']} ${h['month']}, ${h['year']} ${locales.hijri}';

        return Text(hijriDate);
      },
    );
  }
}

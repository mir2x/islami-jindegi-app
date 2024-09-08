import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:native_app/providers/hijri_date_settings.dart';
import 'package:native_app/helpers/adjusted_hijri_date.dart';
import 'package:native_app/helpers/split_hijri_date.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';
import 'package:native_app/theme/app_theme.dart';

class HijriDate extends ConsumerWidget {
  const HijriDate({
    super.key,
    this.currentDate,
    this.count,
    this.oppositeColor = false,
  });

  final HijriCalendar? currentDate;
  final int? count;
  final bool oppositeColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var settingsProvider = ref.watch(hijriDateSettingsProvider);

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return settingsProvider.when(
          loading: () {
            String? hijriDate = preferences.getString('hijriDate');
            String hijriText;

            if (hijriDate != null) {
              hijriText = '$hijriDate ${locales.hijri}';
            } else {
              HijriCalendar date = HijriCalendar.now();

              Map h = splitHijriDate(date, locales, currentLang);
              hijriText =
                  '${h['day']} ${h['month']}, ${h['year']} ${locales.hijri}';
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  hijriText,
                  style: textTheme.labelMedium?.copyWith(
                    color: oppositeColor
                        ? AppTheme.labelOppsititeColor[theme]
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            );
          },
          error: (error, _) => Text(error.toString()),
          data: (Map settings) {
            HijriCalendar today;

            if (currentDate != null) {
              today = currentDate!;
            } else {
              today = adjustedHijriDate(settings);
            }

            Map h = splitHijriDate(today, locales, currentLang);
            String hijriDate = '${h['day']} ${h['month']}, ${h['year']}';
            String hijriText = '$hijriDate ${locales.hijri}';

            if (preferences.getString('hijriDate') != hijriDate) {
              preferences.setString('hijriDate', hijriDate);
              updateAppWidget({'hijriDate': hijriDate});
            }

            return Text(
              hijriText,
              style: textTheme.labelMedium?.copyWith(
                color:
                    oppositeColor ? AppTheme.labelOppsititeColor[theme] : null,
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:native_app/helpers/get_gregorian_date.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class GregorianDate extends StatelessWidget {
  const GregorianDate({
    super.key,
    this.currentDate,
    this.count,
    this.oppositeColor = false,
  });

  final DateTime? currentDate;
  final int? count;
  final bool oppositeColor;

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    return WithPreferences(
      builder: (context, preferences) {
        String gregorianDate = getGregorianDate(currentLang, null);

        if (preferences.getString('gregorianDate') != gregorianDate) {
          preferences.setString('gregorianDate', gregorianDate);
          updateAppWidget({'gregorianDate': gregorianDate});
        }

        return Text(
          getGregorianDate(currentLang, currentDate),
          style: textTheme.labelSmall?.copyWith(
            color: oppositeColor ? appColors.appBarText : null,
          ),
        );
      },
    );
  }
}

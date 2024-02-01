import 'package:flutter/material.dart';
import 'package:native_app/helpers/get_gregorian_date.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

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

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return Text(
          getGregorianDate(currentLang, currentDate),
          style: textTheme.labelSmall?.copyWith(
            color: oppositeColor ? AppTheme.labelOppsititeColor[theme] : null,
          ),
        );
      },
    );
  }
}

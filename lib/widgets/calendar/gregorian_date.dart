import 'package:flutter/material.dart';
import 'package:native_app/helpers/get_gregorian_date.dart';

class GregorianDate extends StatelessWidget {
  const GregorianDate({
    super.key,
    this.currentDate,
    this.count,
  });

  final DateTime? currentDate;
  final int? count;

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;

    return Text(
      getGregorianDate(currentLang, currentDate),
      style: textTheme.labelSmall,
    );
  }
}

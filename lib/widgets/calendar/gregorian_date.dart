import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:native_app/helpers/update_app_widget.dart';

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

    final DateTime today = currentDate ?? DateTime.now();
    String date = DateFormat('EEEE, dd MMMM, yyyy', currentLang).format(today);

    updateAppWidget({'gregorianDate': date});

    return Text(
      date,
      style: textTheme.labelSmall,
    );
  }
}

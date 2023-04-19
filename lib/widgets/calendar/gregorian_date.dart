import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GregorianDate extends StatelessWidget {
  const GregorianDate({super.key});

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;

    final DateTime today = DateTime.now();

    return Text(
      DateFormat('EEEE, dd MMMM, yyyy', currentLang).format(today),
      style: textTheme.labelSmall,
    );
  }
}

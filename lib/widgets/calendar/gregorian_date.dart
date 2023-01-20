import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GregorianDate extends StatelessWidget {
  const GregorianDate({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    final DateTime today = DateTime.now();

    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        DateFormat('EEEE, dd MMMM, yyyy').format(today),
        style: textTheme.labelSmall,
      ),
    );
  }
}

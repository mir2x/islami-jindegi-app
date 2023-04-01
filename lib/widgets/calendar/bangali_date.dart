import 'package:flutter/material.dart';
import 'package:native_app/objects/bongabdo.dart';

class BangaliDate extends StatelessWidget {
  const BangaliDate({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    final today = Bongabdo.now();

    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Text(
        '${today.bDay} ${today.bMonth}, ${today.bYear} বঙ্গাব্দ',
        style: textTheme.labelSmall,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:native_app/objects/bongabdo.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class BangaliDate extends StatelessWidget {
  const BangaliDate({
    super.key,
    this.count,
  });

  final int? count;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    final today = Bongabdo.now();
    String date = '${today.bDay} ${today.bMonth}, ${today.bYear} বঙ্গাব্দ';

    updateAppWidget({'bangaliDate': date});

    return Container(
      margin: const EdgeInsets.only(top: 1),
      child: Text(
        date,
        style: textTheme.labelSmall,
      ),
    );
  }
}

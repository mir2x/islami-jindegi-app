import 'package:flutter/material.dart';
import 'package:native_app/helpers/get_bangali_date.dart';

class BangaliDate extends StatelessWidget {
  const BangaliDate({
    super.key,
    this.count,
  });

  final int? count;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 1),
      child: Text(
        getBangaliDate(),
        style: textTheme.labelSmall,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:native_app/helpers/get_bangali_date.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class BangaliDate extends StatelessWidget {
  const BangaliDate({
    super.key,
    this.count,
    this.oppositeColor = false,
  });

  final int? count;
  final bool oppositeColor;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return Container(
          margin: const EdgeInsets.only(top: 1),
          child: Text(
            getBangaliDate(),
            style: textTheme.labelSmall?.copyWith(
              color: oppositeColor ? AppTheme.labelOppsititeColor[theme] : null,
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:native_app/helpers/get_bangali_date.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';
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
        String bangaliDate = getBangaliDate();

        if (preferences.getString('bangaliDate') != bangaliDate) {
          preferences.setString('bangaliDate', bangaliDate);
          updateAppWidget({'bangaliDate': bangaliDate});
        }

        return Container(
          margin: const EdgeInsets.only(top: 1),
          child: Text(
            bangaliDate,
            style: textTheme.labelSmall?.copyWith(
              color: oppositeColor ? AppTheme.labelOppsititeColor[theme] : null,
            ),
          ),
        );
      },
    );
  }
}

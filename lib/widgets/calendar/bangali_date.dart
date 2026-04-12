import 'package:flutter/material.dart';
import 'package:native_app/helpers/get_bangali_date.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class BangaliDate extends StatelessWidget {
  const BangaliDate({
    super.key,
    this.count,
    this.oppositeColor = false,
    this.style,
  });

  final int? count;
  final bool oppositeColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    return WithPreferences(
      builder: (context, preferences) {
        String bangaliDate = getBangaliDate();

        if (preferences.getString('bangaliDate') != bangaliDate) {
          preferences.setString('bangaliDate', bangaliDate);
          updateAppWidget({'bangaliDate': bangaliDate});
        }

        return Container(
          margin: const EdgeInsets.only(top: 1),
          child: Text(
            bangaliDate,
            style: style ??
                textTheme.labelSmall?.copyWith(
                  color: oppositeColor ? appColors.appBarText : null,
                ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Next extends StatelessWidget {
  const Next({
    super.key,
    required this.onNext,
    this.nextDisabled = false,
    this.contrastColor = true,
    this.iconColor,
  });

  final Future? Function() onNext;
  final bool nextDisabled;
  final bool contrastColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final controlColor = isClassic ? colors.appBarBg : colors.primary;

    Color? iconColor = nextDisabled
        ? colors.secondaryText
        : contrastColor
            ? controlColor
            : null;
    iconColor = this.iconColor ?? iconColor;

    return IconButton(
      icon: const Icon(Icons.skip_next_rounded),
      color: iconColor,
      padding: const EdgeInsets.only(
        top: 10,
        right: 10,
        bottom: 10,
        left: 5,
      ),
      constraints: const BoxConstraints(),
      onPressed: onNext,
    );
  }
}

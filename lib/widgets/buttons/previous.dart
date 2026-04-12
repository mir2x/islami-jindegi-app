import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Previous extends StatelessWidget {
  const Previous({
    super.key,
    required this.onPrevious,
    this.previousDisabled = false,
    this.contrastColor = true,
    this.iconColor,
  });

  final Future? Function() onPrevious;
  final bool previousDisabled;
  final bool contrastColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final controlColor = isClassic ? colors.appBarBg : colors.primary;

    Color? iconColor = previousDisabled
        ? colors.secondaryText
        : contrastColor
            ? controlColor
            : null;
    iconColor = this.iconColor ?? iconColor;

    return IconButton(
      icon: const Icon(Icons.skip_previous_rounded),
      color: iconColor,
      padding: const EdgeInsets.only(
        top: 10,
        right: 5,
        bottom: 10,
        left: 10,
      ),
      constraints: const BoxConstraints(),
      onPressed: onPrevious,
    );
  }
}

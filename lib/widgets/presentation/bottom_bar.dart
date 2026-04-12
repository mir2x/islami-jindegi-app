import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = appTheme.primary == AppThemeColors.classic.primary &&
        appTheme.appBarBg == AppThemeColors.classic.appBarBg;
    final borderColor = isClassic
        ? appTheme.secondary.withValues(alpha: 0.26)
        : appTheme.divider.withValues(alpha: 0.78);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: appTheme.cardBg.withValues(alpha: 0.97),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: borderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: appTheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: alignment,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

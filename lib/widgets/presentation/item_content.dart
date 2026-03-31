import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class ItemContent extends StatelessWidget {
  const ItemContent({
    super.key,
    required this.children,
    this.fullWidth = false,
  });

  final List<Widget> children;

  /// When true: no side margins, no border, no rounded corners —
  /// the content fills the full screen width.
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 900 ? 860.0 : double.infinity;

    return SingleChildScrollView(
      child: Container(
        margin: fullWidth
            ? const EdgeInsets.only(top: 0, bottom: 50)
            : const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 50),
        child: Center(
          child: Container(
            width: contentWidth,
            padding: fullWidth
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 18)
                : const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: appColors.cardBg.withValues(alpha: 0.84),
              borderRadius: fullWidth ? BorderRadius.zero : BorderRadius.circular(24),
              border: fullWidth
                  ? null
                  : Border.all(color: appColors.divider.withValues(alpha: 0.45)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

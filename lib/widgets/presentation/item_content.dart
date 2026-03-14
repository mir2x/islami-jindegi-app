import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class ItemContent extends StatelessWidget {
  const ItemContent({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 900 ? 860.0 : double.infinity;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: 50,
        ),
        child: Center(
          child: Container(
            width: contentWidth,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: appColors.cardBg.withValues(alpha: 0.84),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: appColors.divider.withValues(alpha: 0.45),
              ),
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

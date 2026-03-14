import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class DescriptionItem extends StatelessWidget {
  const DescriptionItem({
    super.key,
    required this.title,
    required this.description,
    this.alignment = CrossAxisAlignment.start,
    this.textWidth = 125,
  });

  final String title;
  final Widget description;
  final CrossAxisAlignment alignment;
  final double textWidth;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: appTheme.highlight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appTheme.divider),
      ),
      child: Row(
        crossAxisAlignment: alignment,
        children: [
          SizedBox(
            width: textWidth,
            child: Text(
              title,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: appTheme.primaryText,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              child: description,
            ),
          ),
        ],
      ),
    );
  }
}

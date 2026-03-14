import 'package:flutter/material.dart';
import 'package:native_app/theme/app_theme_color.dart';

class AyahPlaceholder extends StatelessWidget {
  const AyahPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: colors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.divider),
      ),
      child: Container(
        height: 150.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colors.highlight,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              height: 16,
              width: double.infinity,
              color: colors.highlight,
            ),
            const SizedBox(height: 8),
            Container(height: 16, width: 200, color: colors.highlight),
          ],
        ),
      ),
    );
  }
}

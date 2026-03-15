import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/theme/app_theme_color.dart';

class FontResizer extends ConsumerWidget {
  const FontResizer({
    super.key,
    required this.fontSizeRatio,
    this.text,
    this.storeKey,
    this.contrastColor = true,
  });

  final FontSizeRatio fontSizeRatio;
  final String? text;
  final String? storeKey;
  final bool contrastColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    Color? textColor = contrastColor ? colors.secondary : null;
    Color? iconColor = contrastColor ? colors.secondary : null;

    return WithPreferences(
      builder: (context, preferences) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text ?? locales.font,
              style: textTheme.labelMedium?.copyWith(color: textColor),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              color: iconColor,
              padding: const EdgeInsets.only(
                top: 10,
                right: 5,
                bottom: 10,
                left: 10,
              ),
              constraints: const BoxConstraints(),
              onPressed: () async {
                double ratio = fontSizeRatio.increment();

                if (storeKey != null) {
                  await preferences.setDouble(storeKey!, ratio);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              color: iconColor,
              padding: const EdgeInsets.only(
                top: 10,
                right: 10,
                bottom: 10,
                left: 5,
              ),
              constraints: const BoxConstraints(),
              onPressed: () async {
                double ratio = fontSizeRatio.decrement();

                if (storeKey != null) {
                  await preferences.setDouble(storeKey!, ratio);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

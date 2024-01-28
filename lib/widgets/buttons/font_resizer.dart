import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/objects/font_size_ratio.dart';

class FontResizer extends ConsumerWidget {
  const FontResizer({
    super.key,
    required this.fontSizeRatio,
    this.text,
    this.storeKey,
  });

  final FontSizeRatio fontSizeRatio;
  final String? text;
  final String? storeKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return WithPreferences(
      builder: (context, preferences) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text ?? locales.font,
              style: textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.add),
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

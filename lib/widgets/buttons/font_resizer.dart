import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/objects/font_size_ratio.dart';

class FontResizer extends StatelessWidget {
  const FontResizer({
    super.key,
    required this.fontSizeRatio,
  });

  final FontSizeRatio fontSizeRatio;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(locales.fontSize, style: textTheme.labelMedium),
        IconButton(
          icon: const Icon(Icons.add),
          padding: const EdgeInsets.only(
            top: 10,
            right: 5,
            bottom: 10,
            left: 10,
          ),
          constraints: const BoxConstraints(),
          onPressed: () => fontSizeRatio.increment(),
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
          onPressed: () => fontSizeRatio.decrement(),
        ),
      ],
    );
  }
}

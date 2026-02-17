import 'package:flutter/material.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class Previous extends StatelessWidget {
  const Previous({
    super.key,
    required this.onPrevious,
    this.previousDisabled = false,
    this.contrastColor = true,
  });

  final Future? Function() onPrevious;
  final bool previousDisabled;
  final bool contrastColor;

  @override
  Widget build(BuildContext context) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        Color? iconColor = previousDisabled
            ? Colors.grey
            : contrastColor
                ? AppTheme.titleContrastColor[theme]
                : null;

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
      },
    );
  }
}

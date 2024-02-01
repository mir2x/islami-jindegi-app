import 'package:flutter/material.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class Next extends StatelessWidget {
  const Next({
    super.key,
    required this.onNext,
    this.nextDisabled = false,
    this.contrastColor = true,
  });

  final Future? Function() onNext;
  final bool nextDisabled;
  final bool contrastColor;

  @override
  Widget build(BuildContext context) {
    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        Color? iconColor = nextDisabled
            ? Colors.grey
            : contrastColor
                ? AppTheme.titleContrastColor[theme]
                : null;

        return IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: iconColor,
          padding: const EdgeInsets.only(
            top: 10,
            right: 10,
            bottom: 10,
            left: 5,
          ),
          constraints: const BoxConstraints(),
          onPressed: onNext,
        );
      },
    );
  }
}

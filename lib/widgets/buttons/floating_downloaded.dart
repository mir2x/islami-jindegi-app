import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme.dart';

class FloatingDownloadedButton extends ConsumerWidget {
  const FloatingDownloadedButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final Future? Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

        return FloatingActionButton.extended(
          onPressed: onPressed,
          icon: const Icon(Icons.download),
          label: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppTheme.labelContrastColor[theme],
            ),
          ),
        );
      },
    );
  }
}

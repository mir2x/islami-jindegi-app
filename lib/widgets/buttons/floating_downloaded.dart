import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

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
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: colors.appBarBg,
      foregroundColor: colors.appBarText,
      icon: const Icon(Icons.download),
      label: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          color: colors.appBarText,
        ),
      ),
    );
  }
}

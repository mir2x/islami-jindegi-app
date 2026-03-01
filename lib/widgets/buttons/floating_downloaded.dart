import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    var colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.download),
      label: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

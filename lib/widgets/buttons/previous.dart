import 'package:flutter/material.dart';

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
    var colorScheme = Theme.of(context).colorScheme;

    Color? iconColor = previousDisabled
        ? Theme.of(context).colorScheme.outlineVariant
        : contrastColor
            ? colorScheme.primary
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
  }
}

import 'package:flutter/material.dart';

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
    var colorScheme = Theme.of(context).colorScheme;

    Color? iconColor = nextDisabled
        ? Theme.of(context).colorScheme.outlineVariant
        : contrastColor
            ? colorScheme.primary
            : null;

    return IconButton(
      icon: const Icon(Icons.skip_next_rounded),
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBar extends ConsumerWidget {
  const BottomBar({
    super.key,
    required this.children,
    this.alignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: EdgeInsets.zero,
      height: 52,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Row(
          mainAxisAlignment: alignment,
          children: children,
        ),
      ),
    );
  }
}

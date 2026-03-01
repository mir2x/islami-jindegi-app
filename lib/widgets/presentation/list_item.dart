import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListItem extends ConsumerWidget {
  const ListItem({
    super.key,
    required this.item,
    this.highlightProvider,
  });

  final Widget item;
  final dynamic highlightProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue? highlighter;

    if (highlightProvider != null) {
      highlighter = ref.watch(highlightProvider);
    }

    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: highlighter?.when(
          loading: () => null,
          error: (error, _) => null,
          data: (highlight) {
            if (highlight != null) {
              return Border.all(color: colorScheme.outlineVariant, width: 1);
            } else {
              return null;
            }
          },
        ),
        borderRadius: BorderRadius.circular(15),
        color: colorScheme.surface,
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      child: item,
    );
  }
}

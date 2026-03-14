import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

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
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    AsyncValue? highlighter;

    if (highlightProvider != null) {
      highlighter = ref.watch(highlightProvider);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.cardBg,
        border: highlighter?.when(
          loading: () => null,
          error: (error, _) => null,
          data: (highlight) {
            if (highlight != null) {
              return Border.all(color: appTheme.highlightBorder, width: 1.2);
            } else {
              return Border.all(color: appTheme.divider, width: 1);
            }
          },
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: appTheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      child: item,
    );
  }
}

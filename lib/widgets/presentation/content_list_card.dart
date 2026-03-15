import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

class ContentListCard extends ConsumerWidget {
  const ContentListCard({
    super.key,
    required this.child,
    this.highlightProvider,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final dynamic highlightProvider;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    AsyncValue? highlighter;

    if (highlightProvider != null) {
      highlighter = ref.watch(highlightProvider);
    }

    final border = highlighter?.when(
      loading: () => Border.all(color: colors.divider, width: 1),
      error: (_, __) => Border.all(color: colors.divider, width: 1),
      data: (highlight) => Border.all(
        color: highlight != null ? colors.highlightBorder : colors.divider,
        width: highlight != null ? 1.25 : 1,
      ),
    );

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: border ?? Border.all(color: colors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

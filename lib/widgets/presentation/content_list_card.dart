import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

class ContentListCard extends ConsumerWidget {
  const ContentListCard({
    super.key,
    required this.child,
    this.highlightProvider,
    this.recentlyVisited = false,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final dynamic highlightProvider;

  /// When true the card background uses [AppThemeColors.highlight] to
  /// visually distinguish the most-recently-opened item in the list.
  final bool recentlyVisited;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
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

    Color recentBg;
    Border recentBorder;
    if (recentlyVisited && (isDark || isClassic)) {
      final accentColor = isClassic ? colors.appBarBg : colors.active;
      recentBg = Color.alphaBlend(
        accentColor.withValues(alpha: 0.22),
        colors.cardBg,
      );
      recentBorder = Border.all(
        color: accentColor.withValues(alpha: 0.48),
        width: 1.25,
      );
    } else {
      recentBg = recentlyVisited ? colors.highlight : colors.cardBg;
      recentBorder = Border.all(
        color: recentlyVisited ? colors.highlightBorder : colors.divider,
        width: recentlyVisited ? 1.25 : 1,
      );
    }

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: recentBg,
        borderRadius: BorderRadius.circular(20),
        border: recentlyVisited ? recentBorder : (border ?? recentBorder),
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


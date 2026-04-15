import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';

class ListItem extends ConsumerWidget {
  const ListItem({
    super.key,
    required this.item,
    this.highlightProvider,
    this.recentlyVisited = false,
  });

  final Widget item;
  final dynamic highlightProvider;

  /// When true the card background uses [AppThemeColors.highlight] to
  /// visually distinguish the most-recently-opened item in the list.
  final bool recentlyVisited;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = Theme.of(context).extension<AppThemeColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClassic = appTheme.primary == AppThemeColors.classic.primary &&
        appTheme.appBarBg == AppThemeColors.classic.appBarBg;
    AsyncValue? highlighter;

    if (highlightProvider != null) {
      highlighter = ref.watch(highlightProvider);
    }

    Color recentBg;
    Border recentBorder;
    if (recentlyVisited && (isDark || isClassic)) {
      final accentColor = isClassic ? appTheme.appBarBg : appTheme.active;
      recentBg = Color.alphaBlend(
        accentColor.withValues(alpha: 0.22),
        appTheme.cardBg,
      );
      recentBorder = Border.all(
        color: accentColor.withValues(alpha: 0.48),
        width: 1.25,
      );
    } else {
      recentBg = recentlyVisited ? appTheme.highlight : appTheme.cardBg;
      recentBorder = Border.all(
        color: recentlyVisited ? appTheme.highlightBorder : appTheme.divider,
        width: recentlyVisited ? 1.25 : 1,
      );
    }

    final highlightBorder = highlighter?.when(
      loading: () => Border.all(color: appTheme.divider, width: 1),
      error: (error, _) => Border.all(color: appTheme.divider, width: 1),
      data: (highlight) {
        if (highlight != null) {
          return Border.all(color: appTheme.highlightBorder, width: 1.2);
        } else {
          return Border.all(color: appTheme.divider, width: 1);
        }
      },
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: recentBg,
        border: recentlyVisited ? recentBorder : (highlightBorder ?? recentBorder),
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


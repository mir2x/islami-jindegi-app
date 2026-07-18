import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'with_last_visited.dart';

class LastVisited extends ConsumerWidget {
  const LastVisited({
    super.key,
    required this.resourceKey,
    required this.resourceId,
    this.isAudio = false,
  });

  final String resourceKey;
  final String resourceId;

  /// true  → "Recently Listened"
  /// false → "Recently Read"
  final bool isAudio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;

    final accentColor = isClassic ? colors.appBarBg : colors.active;
    final chipBg = (isDark || isClassic)
        ? accentColor.withValues(alpha: 0.28)
        : colors.highlight;
    final chipBorder = (isDark || isClassic)
        ? accentColor.withValues(alpha: 0.55)
        : colors.highlightBorder;
    final chipText = (isDark || isClassic)
        ? accentColor
        : colors.secondaryText;

    return WithLastVisited(
      builder: (context, settings) {
        if (settings.getString(resourceKey) != resourceId) {
          return const SizedBox.shrink();
        }

        final label = isAudio ? locales.recentlyListened : locales.recentlyRead;

        return Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: chipBorder, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: chipText,
              height: 1.2,
            ),
          ),
        );
      },
    );
  }
}

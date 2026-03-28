import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            color: colors.highlight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.highlightBorder, width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.secondaryText,
              height: 1.2,
            ),
          ),
        );
      },
    );
  }
}

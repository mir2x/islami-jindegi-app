import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura_list/providers/sura_list_providers.dart';
import 'package:native_app/shared/quran_data.dart';
import 'package:native_app/theme/app_theme_color.dart';

class SuraAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final int suraNumber;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// When provided, replaces the default actions entirely.
  final List<Widget>? actions;

  const SuraAppBar({
    super.key,
    required this.title,
    required this.suraNumber,
    this.scaffoldKey,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahInfo = surahInfoList[suraNumber - 1];
    final subtitle =
        '${surahInfo.typeLabel} | আয়াত সংখ্যা: ${surahInfo.ayatCount.toBengaliDigit()}';
    final colorScheme = Theme.of(context).colorScheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = colorScheme.brightness == Brightness.light;
    final bg = isLight
        ? colors.surfaceBg
        : (Theme.of(context).appBarTheme.backgroundColor ?? colorScheme.surface);
    final fg = isLight
        ? colors.secondaryText
        : (Theme.of(context).appBarTheme.foregroundColor ?? colorScheme.onSurface);

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          ref.read(lastViewedSuraProvider.notifier).state = suraNumber;
          context.go('/qurans/sura-list');
        },
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              wordSpacing: 3,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: fg.withValues(alpha: 0.7),
              fontSize: 12,
              wordSpacing: 3,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: actions ??
          [
            if (scaffoldKey != null)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => scaffoldKey!.currentState?.openDrawer(),
              ),
            IconButton(
              icon: const Icon(Icons.menu_book),
              onPressed: () =>
                  context.push('/qurans/tilawat?sura=$suraNumber&ayah=1'),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/qurans/search'),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

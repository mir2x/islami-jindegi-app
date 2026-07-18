import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/features/sura_list/providers/sura_list_providers.dart';
import 'package:native_app/shared/quran_data.dart';
import 'package:native_app/theme/app_theme_color.dart';

class SuraAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final int suraNumber;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final int currentAyahNumber;
  final String? returnTo;
  final bool popBack;

  /// When provided, replaces the default actions entirely.
  final List<Widget>? actions;

  const SuraAppBar({
    super.key,
    required this.title,
    required this.suraNumber,
    this.scaffoldKey,
    this.currentAyahNumber = 1,
    this.returnTo,
    this.popBack = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahInfo = surahInfoList[suraNumber - 1];
    final subtitle =
        '${surahInfo.typeLabel} | আয়াত সংখ্যা: ${surahInfo.ayatCount.toBengaliDigit()}';
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final bg = colors.appBarBg;
    final fg = colors.appBarText;

    return AppBar(
      backgroundColor: bg,
      foregroundColor: fg,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          ref.read(lastViewedSuraProvider.notifier).set(suraNumber);
          if (popBack && context.canPop()) {
            context.pop();
          } else {
            context.go(returnTo ?? suraListRoute);
          }
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
              onPressed: () => context.push(
                buildTilawatRoute(
                  suraNumber: suraNumber,
                  ayahNumber: currentAyahNumber,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push(
                buildSearchRoute(returnTo: returnTo ?? suraListRoute),
              ),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

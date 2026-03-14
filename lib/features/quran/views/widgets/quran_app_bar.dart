import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme_color.dart';
import '../../models/ayah_box.dart';
import '../../providers/ayah_highlight_providers.dart';

class QuranAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isLandscape;

  const QuranAppBar({super.key, this.isLandscape = false});

  @override
  Size get preferredSize => Size.fromHeight(isLandscape ? 52.0 : 64.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locales = AppLocalizations.of(context)!;
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final iconSize = isLandscape ? 20.0 : 24.0;
    final appBarBg = colors.appBarBg;
    final appBarFg = colors.appBarText;
    final isDarkBg =
        ThemeData.estimateBrightnessForColor(appBarBg) == Brightness.dark;

    return AppBar(
      toolbarHeight: isLandscape ? 52.0 : 64.0,
      backgroundColor: appBarBg,
      foregroundColor: appBarFg,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: appBarBg,
        statusBarIconBrightness: isDarkBg ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkBg ? Brightness.dark : Brightness.light,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,

      // ── Back Button ─────────────────────────
      leading: _AppBarIconButton(
        icon: Icons.arrow_back,
        iconSize: iconSize,
        color: appBarFg,
        onPressed: () => Navigator.of(context).maybePop(),
      ),

      // ── Title ───────────────────────────────
      title: Text(
        locales.quran,
        style: TextStyle(
          color: appBarFg,
          fontSize: isLandscape ? 18.0 : 22.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          letterSpacing: 1.2,
          wordSpacing: 3,
        ),
      ),
      centerTitle: true,

      // ── Action Icons ─────────────────────────
      actions: [
        // Drawer (menu)
        _AppBarIconButton(
          icon: Icons.menu_rounded,
          iconSize: iconSize,
          color: appBarFg,
          onPressed: () {
            final scaffold = Scaffold.maybeOf(context);
            if (scaffold != null) {
              scaffold.openDrawer();
            }
          },
        ),

        // Translate
        _AppBarIconButton(
          icon: Icons.g_translate_rounded,
          iconSize: iconSize,
          color: appBarFg,
          onPressed: () {
            final target = _resolveSuraNavigationTarget(ref);
            context.push(
              '/qurans/sura/${target.suraNumber}?scroll=${target.ayahNumber - 1}',
            );
          },
        ),

        // Search
        _AppBarIconButton(
          icon: Icons.search_rounded,
          iconSize: iconSize,
          color: appBarFg,
          onPressed: () => context.push('/qurans/search'),
        ),

        SizedBox(width: 4.w),
      ],
    );
  }

  _SuraNavigationTarget _resolveSuraNavigationTarget(WidgetRef ref) {
    final selectedAyah = ref.read(selectedAyahProvider);
    if (selectedAyah != null) {
      return _SuraNavigationTarget(
        suraNumber: selectedAyah.suraNumber,
        ayahNumber: selectedAyah.ayahNumber,
      );
    }

    final currentPage = ref.read(currentPageProvider) + 1;
    final pageBoxes = ref.read(boxesForPageProvider(currentPage));
    if (pageBoxes.isNotEmpty) {
      final firstAyahBox = _findFirstAyahOnPage(pageBoxes);
      return _SuraNavigationTarget(
        suraNumber: firstAyahBox.suraNumber,
        ayahNumber: firstAyahBox.ayahNumber,
      );
    }

    return _SuraNavigationTarget(
      suraNumber: ref.read(currentSuraProvider),
      ayahNumber: 1,
    );
  }

  AyahBox _findFirstAyahOnPage(List<AyahBox> pageBoxes) {
    final sortedBoxes = [...pageBoxes]..sort((a, b) {
        final topCompare = a.minY.compareTo(b.minY);
        if (topCompare != 0) return topCompare;

        final rightToLeftCompare = b.maxX.compareTo(a.maxX);
        if (rightToLeftCompare != 0) return rightToLeftCompare;

        final suraCompare = a.suraNumber.compareTo(b.suraNumber);
        if (suraCompare != 0) return suraCompare;

        final ayahCompare = a.ayahNumber.compareTo(b.ayahNumber);
        if (ayahCompare != 0) return ayahCompare;

        return a.boxId.compareTo(b.boxId);
      });

    return sortedBoxes.first;
  }
}

class _SuraNavigationTarget {
  final int suraNumber;
  final int ayahNumber;

  const _SuraNavigationTarget({
    required this.suraNumber,
    required this.ayahNumber,
  });
}

// ─────────────────────────────────────────
//  REUSABLE APPBAR ICON BUTTON
// ─────────────────────────────────────────

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color color;
  final VoidCallback onPressed;

  const _AppBarIconButton({
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: colors.highlight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        child: IconButton(
          icon: Icon(icon, color: color),
          iconSize: iconSize,
          splashRadius: iconSize,
          splashColor: colors.selectionOverlay,
          highlightColor: colors.selectionOverlay.withValues(alpha: 0.45),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

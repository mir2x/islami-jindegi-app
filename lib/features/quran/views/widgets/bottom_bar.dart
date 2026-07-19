import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../theme/app_theme_color.dart';
import '../../models/bookmark.dart';
import '../../providers/ayah_highlight_providers.dart';
import '../../providers/bookmark_providers.dart';
import '../../providers/reciter_providers.dart';
import 'audio_bottom_sheet.dart';

class BottomBar extends ConsumerWidget {
  final bool drawerOpen;
  final GlobalKey<ScaffoldState> rootKey;
  final bool isLandscape;

  const BottomBar({
    super.key,
    required this.drawerOpen,
    required this.rootKey,
    required this.isLandscape,
  });

  // ── Dimensions ───────────────────────────
  double get _height => isLandscape ? 50.0 : 64.0.h;
  double get _iconSize => isLandscape ? 20.0 : 24.0.r;
  double get _dropdownHeight => isLandscape ? 32.0 : 40.0.h;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final barBg = colors.appBarBg;
    final barFg = colors.appBarText;

    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: barBg,
        border: Border(
          top: BorderSide(color: colors.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Play Audio ─────────────────────
          _NavIconButton(
            icon: HugeIcons.strokeRoundedPlay,
            iconSize: _iconSize,
            color: barFg,
            isLandscape: isLandscape,
            onPressed: () => _openAudioSheet(context, ref),
          ),

          // ── Reciter Dropdown ───────────────
          Expanded(
            child: _ReciterDropdown(
              isLandscape: isLandscape,
              height: _dropdownHeight,
              colors: colors,
              ref: ref,
            ),
          ),

          SizedBox(width: 4.w),

          // ── Touch Mode Toggle ──────────────
          Consumer(
            builder: (_, ref, __) {
              final isOn = ref.watch(touchModeProvider);
              return _NavIconButton(
                icon: HugeIcons.strokeRoundedTouchLocked03,
                iconSize: isLandscape ? 20.0 : 26.0.r,
                color: isOn ? colors.secondary : barFg,
                isLandscape: isLandscape,
                onPressed: () {
                  ref.read(touchModeProvider.notifier).toggle();
                  ref.read(selectedAyahProvider.notifier).clear();
                },
              );
            },
          ),

          // ── Orientation Toggle ─────────────
          _NavIconButton(
            icon: HugeIcons.strokeRoundedScreenRotation,
            iconSize: _iconSize,
            color: barFg,
            isLandscape: isLandscape,
            onPressed: OrientationToggle.toggle,
          ),

          // ── Bookmark ───────────────────────
          _BookmarkButton(
            isLandscape: isLandscape,
            iconSize: _iconSize,
            colors: colors,
          ),

          // ── Drawer Toggle ──────────────────
          _NavIconButton(
            icon: HugeIcons.strokeRoundedNavigation05,
            iconSize: _iconSize,
            color: drawerOpen ? colors.secondary : barFg,
            isLandscape: isLandscape,
            onPressed: () => drawerOpen
                ? rootKey.currentState?.closeDrawer()
                : rootKey.currentState?.openDrawer(),
          ),
        ],
      ),
    );
  }

  void _openAudioSheet(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.drawerScrim.withValues(alpha: 0),
      builder: (_) => AudioBottomSheet(
        currentSura: ref.read(currentSuraProvider),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  RECITER DROPDOWN
// ─────────────────────────────────────────

class _ReciterDropdown extends StatelessWidget {
  final bool isLandscape;
  final double height;
  final AppThemeColors colors;
  final WidgetRef ref;

  const _ReciterDropdown({
    required this.isLandscape,
    required this.height,
    required this.colors,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final fieldBg = colors.dropdownBg;
    final menuBg = colors.dropdownBg;
    final textColor = colors.primaryText;

    final selectedReciter = ref.watch(selectedReciterProvider);
    final displayReciterName =
        reciters.entries.firstWhere((e) => e.value == selectedReciter).key;

    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
        vertical: isLandscape ? 8.0 : 12.0.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: fieldBg,
        border: Border.all(color: colors.divider),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: menuBg,
          iconEnabledColor: colors.secondary,
          style: TextStyle(
            color: textColor,
            fontSize: isLandscape ? 13.0 : 13.0.sp,
            fontFamily: 'Poppins',
          ),
          value: displayReciterName,
          items: reciters.keys.map((name) {
            return DropdownMenuItem(
              value: name,
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: isLandscape ? 13.0 : 13.0.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(selectedReciterProvider.notifier).setReciter(reciters[val]!);
            }
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  BOOKMARK BUTTON
// ─────────────────────────────────────────

class _BookmarkButton extends ConsumerWidget {
  final bool isLandscape;
  final double iconSize;
  final AppThemeColors colors;

  const _BookmarkButton({
    required this.isLandscape,
    required this.iconSize,
    required this.colors,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider) + 1;
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    ref.watch(bookmarkProvider); // rebuild on bookmark changes
    final isBookmarked = bookmarkNotifier.isPageBookmarked(currentPage);

    return _NavIconButton(
      icon: HugeIcons.strokeRoundedStar,
      iconSize: iconSize,
      color: isBookmarked ? colors.secondary : colors.appBarText,
      isLandscape: isLandscape,
      onPressed: () => _handleBookmark(
          context, ref, isBookmarked, currentPage, bookmarkNotifier),
    );
  }

  void _handleBookmark(
    BuildContext context,
    WidgetRef ref,
    bool isBookmarked,
    int currentPage,
    dynamic bookmarkNotifier,
  ) {
    if (!context.mounted) return;
    final identifier = 'page-$currentPage';

    if (isBookmarked) {
      bookmarkNotifier.remove(identifier);
      _showSnack(context, 'পৃষ্ঠা বুকমার্ক থেকে সরানো হয়েছে');
      return;
    }

    final quranInfoService = ref.read(quranInfoServiceProvider);
    final sura = quranInfoService.getSuraByPage(currentPage);
    final para = quranInfoService.getParaByPage(currentPage);

    if (sura != null && para != null) {
      bookmarkNotifier.add(Bookmark(
        type: 'page',
        identifier: identifier,
        sura: sura,
        para: para,
        page: currentPage,
      ));
      _showSnack(context, 'পৃষ্ঠা বুকমার্ক করা হয়েছে');
    } else {
      _showSnack(context, 'এই পৃষ্ঠার জন্য সূরা/পারা নির্ধারণ করা যায়নি');
    }
  }

  void _showSnack(BuildContext context, String message) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.cardBg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(color: colors.divider),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: colors.primaryText,
            fontSize: 13.sp,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  REUSABLE NAV ICON BUTTON
// ─────────────────────────────────────────

class _NavIconButton extends StatelessWidget {
  final List<List<dynamic>> icon;
  final double iconSize;
  final Color color;
  final bool isLandscape;
  final VoidCallback onPressed;

  const _NavIconButton({
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.isLandscape,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return IconButton(
      iconSize: iconSize,
      constraints: BoxConstraints(
        minHeight: isLandscape ? 40.0 : 46.0.h,
        minWidth: isLandscape ? 34.0 : 40.0.w,
      ),
      padding: EdgeInsets.zero,
      splashColor: colors.selectionOverlay,
      highlightColor: colors.selectionOverlay.withValues(alpha: 0.1),
      icon: Center(child: HugeIcon(icon: icon, color: color, size: iconSize)),
      onPressed: onPressed,
    );
  }
}

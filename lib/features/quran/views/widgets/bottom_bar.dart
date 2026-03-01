import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:native_app/theme/colors.dart';
import '../../models/bookmark.dart';
import '../../providers/ayah_highlight_providers.dart';
import '../../providers/bookmark_providers.dart';
import '../../providers/reciter_providers.dart';
import 'audio_bottom_sheet.dart';
import '../../../../../core/theme.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedReciter = ref.watch(selectedReciterProvider);
    final displayReciterName =
        reciters.entries.firstWhere((e) => e.value == selectedReciter).key;

    final currentPage = ref.watch(currentPageProvider) + 1;
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final bookmarksAsync = ref.watch(bookmarkProvider);

    final bool isPageBookmarked =
        bookmarkNotifier.isPageBookmarked(currentPage);

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: isLandscape ? 50.0 : bottomBarHeight.h,
      color: colorScheme.primary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconBtn(
            context: context,
            icon: HugeIcons.strokeRoundedPlay,
            isLandscape: isLandscape,
            onPressed: () {
              final sura = ref.watch(currentSuraProvider);
              final page = ref.watch(currentPageProvider);

              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return AudioBottomSheet(
                      currentSura: ref.read(currentSuraProvider));
                },
              );
            },
          ),
          Expanded(
            child: Container(
              height: isLandscape ? 32.0 : 40.h,
              margin: EdgeInsets.symmetric(vertical: isLandscape ? 8.0 : 12.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                border:
                    Border.all(color: colorScheme.onPrimary.withOpacity(0.24)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: colorScheme.primary,
                  iconEnabledColor: colorScheme.onPrimary,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: isLandscape ? 14.0 : 14.sp,
                  ),
                  value: displayReciterName,
                  items: reciters.keys.map((displayName) {
                    return DropdownMenuItem(
                      value: displayName,
                      child: Text(
                        displayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: isLandscape ? 14.0 : 14.sp,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(selectedReciterProvider.notifier).state =
                          reciters[val]!;
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 5.w),
          Consumer(
            builder: (_, ref, __) {
              final on = ref.watch(touchModeProvider);
              return _iconBtn(
                context: context,
                icon: HugeIcons.strokeRoundedTouchLocked03,
                color: on ? colorScheme.tertiary : colorScheme.onPrimary,
                size: isLandscape ? 20.0 : 26.r,
                isLandscape: isLandscape,
                onPressed: () {
                  final wasOn = ref.read(touchModeProvider);
                  ref.read(touchModeProvider.notifier).toggle();
                  // If touch mode was ON and is now turning OFF, clear selection
                  if (wasOn) {
                    ref.read(selectedAyahProvider.notifier).clear();
                  }
                },
              );
            },
          ),
          _iconBtn(
            context: context,
            icon: HugeIcons.strokeRoundedScreenRotation,
            size: isLandscape ? 20.0 : 24.r,
            isLandscape: isLandscape,
            onPressed: () => OrientationToggle.toggle(),
          ),
          _iconBtn(
            context: context,
            icon: isPageBookmarked
                ? Icons.star_rounded
                : HugeIcons.strokeRoundedStar,
            color: isPageBookmarked
                ? colorScheme.secondary
                : colorScheme.onPrimary,
            size: isLandscape ? 20.0 : 24.r,
            isLandscape: isLandscape,
            onPressed: () {
              if (!context.mounted) return;

              final pageToBookmark = ref.read(currentPageProvider) + 1;
              final identifier = 'page-$pageToBookmark';

              if (isPageBookmarked) {
                bookmarkNotifier.remove(identifier);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'পৃষ্ঠা বুকমার্ক থেকে সরানো হয়েছে',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                );
              } else {
                final quranInfoService = ref.read(quranInfoServiceProvider);

                final sura = quranInfoService.getSuraByPage(pageToBookmark);
                final para = quranInfoService.getParaByPage(pageToBookmark);

                if (sura != null && para != null) {
                  final bookmark = Bookmark(
                    type: 'page',
                    identifier: identifier,
                    sura: sura,
                    para: para,
                    page: pageToBookmark,
                  );

                  bookmarkNotifier.add(bookmark);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'পৃষ্ঠা বুকমার্ক করা হয়েছে',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'এই পৃষ্ঠার জন্য সূরা/পারা নির্ধারণ করা যায়নি',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  );
                }
              }
            },
          ),
          _iconBtn(
            context: context,
            icon: HugeIcons.strokeRoundedNavigation05,
            size: isLandscape ? 20.0 : 24.r,
            isLandscape: isLandscape,
            onPressed: () {
              if (drawerOpen) {
                rootKey.currentState?.closeDrawer();
              } else {
                rootKey.currentState?.openDrawer();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    double? size,
    Color? color,
    bool isLandscape = false,
  }) {
    final iconColor = color ?? Theme.of(context).colorScheme.onPrimary;
    return IconButton(
      iconSize: size ?? (isLandscape ? 20.0 : 24.r),
      constraints: BoxConstraints(
        minHeight: isLandscape ? 50.0 : 64.h,
        minWidth: isLandscape ? 40.0 : 48.w,
      ),
      padding: EdgeInsets.zero,
      icon: Center(child: Icon(icon, color: iconColor)),
      onPressed: onPressed,
    );
  }
}

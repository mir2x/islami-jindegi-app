import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/bookmark.dart';
import '../../providers/audio_providers.dart';
import '../../providers/ayah_highlight_providers.dart';
import '../../providers/bookmark_providers.dart';
import '../../../sura/providers/sura_providers.dart';
import 'package:native_app/theme/app_theme_color.dart';

import 'audio_bottom_sheet.dart';

class AyahMenu extends ConsumerWidget {
  const AyahMenu({super.key, required this.anchorRect});

  final Rect anchorRect;

  String toBengaliNumber(int number) {
    const bengaliNumbers = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number
        .toString()
        .split('')
        .map((char) => bengaliNumbers[int.parse(char)])
        .join();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuWidth = 300.w;
    final menuHeight = 60.h;
    final verticalOffset = 10.h;

    final selectedAyahState = ref.watch(selectedAyahProvider);
    if (selectedAyahState == null) {
      return const SizedBox.shrink();
    }

    final double menuLeft = (1.sw - menuWidth) / 2;
    final double menuTop =
        math.max(anchorRect.top - menuHeight - verticalOffset, 0.0);

    final selectedSura = selectedAyahState.suraNumber;
    final selectedAyah = selectedAyahState.ayahNumber;
    final currentPage = ref.watch(currentPageProvider) + 1;
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final isBookmarked =
        bookmarkNotifier.isAyahBookmarked(selectedSura, selectedAyah);

    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Positioned(
      left: menuLeft,
      top: menuTop,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(8.r),
        color: colors.cardBg,
        child: SizedBox(
          height: menuHeight,
          width: menuWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                  icon: HugeIcon(
                    icon: isBookmarked
                        ? Icons.star_rounded
                        : HugeIcons.strokeRoundedStar,
                    color: isBookmarked ? colors.secondary : colors.primaryText,
                    size: 24.r,
                  ),
                  onPressed: () {
                    if (isBookmarked) {
                      final identifier = 'ayah-$selectedSura-$selectedAyah';
                      bookmarkNotifier.remove(identifier);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'আয়াতটি বুকমার্ক থেকে সরানো হয়েছে',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      );
                    } else {
                      final quranInfoService =
                          ref.read(quranInfoServiceProvider);
                      final para = quranInfoService.getParaBySuraAyah(
                          selectedSura, selectedAyah);
                      final bookmark = Bookmark(
                          type: 'ayah',
                          identifier: 'ayah-$selectedSura-$selectedAyah',
                          sura: selectedSura,
                          ayah: selectedAyah,
                          para: para,
                          page: currentPage);
                      bookmarkNotifier.add(bookmark);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('আয়াতটি বুকমার্ক করা হয়েছে',
                              style: TextStyle(fontSize: 14.sp))));
                    }
                    ref.read(selectedAyahProvider.notifier).clear();
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedPlay,
                      color: colors.primaryText,
                      size: 24.r),
                  onPressed: () {
                    final selectedState = ref.read(selectedAyahProvider);
                    if (selectedState == null) return;

                    ref.read(selectedAudioSuraProvider.notifier).set(selectedState.suraNumber);
                    ref.read(selectedStartAyahProvider.notifier).set(selectedState.ayahNumber);
                    ref.read(selectedEndAyahProvider.notifier).set(selectedState.ayahNumber);

                    ref.read(selectedAyahProvider.notifier).clear();

                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return AudioBottomSheet(
                          currentSura: selectedState.suraNumber,
                        );
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCopy01,
                    color: colors.primaryText,
                    size: 24.r,
                  ),
                  onPressed: () async {
                    try {
                      final db = await ref.read(databaseProvider.future);
                      final ayah = await ref
                          .read(quranDataServiceProvider)
                          .getAyah(db, selectedSura, selectedAyah);
                      await Clipboard.setData(
                          ClipboardData(text: ayah.arabicText));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'আয়াতটি কপি হয়েছে',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'কপি করতে ব্যর্থ হয়েছে',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        );
                      }
                    }
                    ref.read(selectedAyahProvider.notifier).clear();
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedShare01,
                      color: colors.primaryText,
                      size: 24.r),
                  onPressed: () async {
                    try {
                      final db = await ref.read(databaseProvider.future);
                      final ayah = await ref
                          .read(quranDataServiceProvider)
                          .getAyah(db, selectedSura, selectedAyah);
                      await Share.share(ayah.arabicText);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'শেয়ার করতে ব্যর্থ হয়েছে',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                        );
                      }
                    }
                    ref.read(selectedAyahProvider.notifier).clear();
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.fullscreen,
                      color: colors.primaryText, size: 24.r),
                  onPressed: () {
                    ref.read(barsVisibilityProvider.notifier).hide();
                    ref.read(selectedAyahProvider.notifier).clear();
                  },
                ),
              ),
              // ── Touch mode toggle ───────────────────────
              Consumer(
                builder: (_, ref, __) {
                  final isOn = ref.watch(touchModeProvider);
                  return Expanded(
                    child: IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedTouchLocked03,
                        color: isOn ? colors.secondary : colors.primaryText,
                        size: 24.r,
                      ),
                      onPressed: () {
                        ref.read(touchModeProvider.notifier).toggle();
                        ref.read(selectedAyahProvider.notifier).clear();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

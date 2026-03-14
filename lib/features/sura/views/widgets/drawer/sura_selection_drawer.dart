import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';
import 'package:native_app/theme/app_theme_color.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedDrawerSurahProvider = StateProvider<int>((ref) => 1);
final selectedDrawerAyahProvider = StateProvider<int?>((ref) => null);

class SuraSelectionDrawer extends ConsumerStatefulWidget {
  final int currentSuraNumber;
  const SuraSelectionDrawer({super.key, required this.currentSuraNumber});

  @override
  ConsumerState<SuraSelectionDrawer> createState() =>
      _SuraSelectionDrawerState();
}

class _SuraSelectionDrawerState extends ConsumerState<SuraSelectionDrawer> {
  final ItemScrollController _surahScrollController = ItemScrollController();
  final ItemScrollController _ayahScrollController = ItemScrollController();
  bool _isInitialStateSet = false;

  String toBengaliNumber(int number) {
    const bengaliNumbers = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String numberStr = number.toString();
    String bengaliStr = '';
    for (int i = 0; i < numberStr.length; i++) {
      int digit = int.parse(numberStr[i]);
      bengaliStr += bengaliNumbers[digit];
    }
    return bengaliStr;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedDrawerSurahProvider.notifier).state =
          widget.currentSuraNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialStateSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _surahScrollController.isAttached) {
          _surahScrollController.jumpTo(index: widget.currentSuraNumber - 1);
        }
      });
      _isInitialStateSet = true;
    }

    final media = MediaQuery.of(context);
    final double topInset = kToolbarHeight + media.padding.top;
    final double bottomInset = media.padding.bottom;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
        child: SizedBox(
          width: 280.w,
          child: Material(
            elevation: 16,
            color: Theme.of(context).extension<AppThemeColors>()!.drawerBg,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _buildSurahList(ref)),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Theme.of(context)
                            .extension<AppThemeColors>()!
                            .divider,
                      ),
                      Expanded(flex: 2, child: _buildAyahList(ref)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final headerBg = appColors.drawerHeaderBg;
    final headerFg = appColors.appBarText;
    return Container(
      color: headerBg,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'সুরা',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: headerFg,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'আয়াত',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: headerFg,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                fontFamily: 'bangla/solaimanlipi',
                wordSpacing: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahList(WidgetRef ref) {
    final selectedSurah = ref.watch(selectedDrawerSurahProvider);
    final suraNames = ref.watch(suraNamesProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final selectedBg = appColors.highlight;
    final selectedFg = appColors.primaryText;

    return ScrollablePositionedList.separated(
      itemScrollController: _surahScrollController,
      padding: EdgeInsets.zero,
      itemCount: 114,
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: appColors.divider),
      itemBuilder: (context, index) {
        final suraNumber = index + 1;
        final isSelected = suraNumber == selectedSurah;

        return ListTile(
          tileColor: isSelected ? selectedBg : null,
          title: Text(
            '${toBengaliNumber(suraNumber)}. ${suraNames[index]}',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? selectedFg
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          onTap: () {
            ref.read(selectedDrawerSurahProvider.notifier).state = suraNumber;
          },
        );
      },
    );
  }

  Widget _buildAyahList(WidgetRef ref) {
    final selectedSurah = ref.watch(selectedDrawerSurahProvider);
    final ayahCounts = ref.watch(ayahCountsProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    if (selectedSurah < 1 || selectedSurah > 114) return const SizedBox();

    final totalAyahs = ayahCounts[selectedSurah - 1];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _ayahScrollController.isAttached) {}
    });

    return ScrollablePositionedList.separated(
      itemScrollController: _ayahScrollController,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: appColors.divider),
      itemCount: totalAyahs,
      itemBuilder: (context, index) {
        final ayahNumber = index + 1;

        return ListTile(
          title: Center(
            child: Text(
              toBengaliNumber(ayahNumber),
              style: TextStyle(
                fontSize: 14.sp,
                color: appColors.primaryText,
              ),
            ),
          ),
          onTap: () {
            _onAyahSelected(context, selectedSurah, ayahNumber);
          },
        );
      },
    );
  }

  void _onAyahSelected(BuildContext context, int suraNumber, int ayahNumber) {
    // Save last read position asynchronously (non-blocking)
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('last_read_sura', suraNumber);
      prefs.setInt('last_read_ayah_index', ayahNumber - 1);
    });

    // Close the drawer first
    Scaffold.of(context).closeDrawer();

    if (suraNumber == widget.currentSuraNumber) {
      // Same sura - just scroll to the ayah
      ref.read(suraScrollCommandProvider.notifier).state = ScrollCommand(
        suraNumber: suraNumber,
        scrollIndex: ayahNumber - 1,
      );
    } else {
      // Different sura:
      // 1. Go back to sura-list
      // 2. Then navigate to the new sura
      // This ensures only one sura is in the stack at any time
      Future.delayed(const Duration(milliseconds: 200), () async {
        if (!context.mounted) return;
        // Go back to sura-list first
        if (context.canPop()) context.pop();
        // Small delay to ensure navigation completes
        await Future.delayed(const Duration(milliseconds: 50));
        if (!context.mounted) return;
        // Navigate to the new sura
        context.push('/qurans/sura/$suraNumber?scroll=${ayahNumber - 1}');
      });
    }
  }
}

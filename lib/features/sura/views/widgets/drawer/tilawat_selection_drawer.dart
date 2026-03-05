import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/theme/app_theme_color.dart';

final _selectedTilawatSurahProvider = StateProvider<int>((ref) => 1);

class TilawatSelectionDrawer extends ConsumerStatefulWidget {
  final int currentSuraNumber;
  const TilawatSelectionDrawer({super.key, required this.currentSuraNumber});

  @override
  ConsumerState<TilawatSelectionDrawer> createState() =>
      _TilawatSelectionDrawerState();
}

class _TilawatSelectionDrawerState
    extends ConsumerState<TilawatSelectionDrawer> {
  final ItemScrollController _surahScrollController = ItemScrollController();
  final ItemScrollController _ayahScrollController = ItemScrollController();
  bool _isInitialStateSet = false;

  String _toBengaliNumber(int number) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((d) => bn[int.parse(d)]).join();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_selectedTilawatSurahProvider.notifier).state =
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
            color: Theme.of(context).colorScheme.surface,
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
                        color: Theme.of(context).dividerColor,
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
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = colorScheme.brightness == Brightness.light;
    final headerBg = isLight ? appColors.appBarBg : colorScheme.secondary;
    final headerFg = isLight ? appColors.appBarText : colorScheme.onSecondary;
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
              'আয়াত',
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
    final selectedSurah = ref.watch(_selectedTilawatSurahProvider);
    final suraNames = ref.watch(suraNamesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = colorScheme.brightness == Brightness.light;
    final selectedBg = isLight
        ? appColors.appBarBg.withOpacity(0.15)
        : colorScheme.primary.withOpacity(0.1);
    final selectedFg = isLight ? appColors.appBarBg : colorScheme.primary;

    return ScrollablePositionedList.separated(
      itemScrollController: _surahScrollController,
      padding: EdgeInsets.zero,
      itemCount: 114,
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: Theme.of(context).dividerColor),
      itemBuilder: (context, index) {
        final suraNumber = index + 1;
        final isSelected = suraNumber == selectedSurah;

        return ListTile(
          tileColor: isSelected
              ? selectedBg
              : null,
          title: Text(
            '${_toBengaliNumber(suraNumber)}. ${suraNames[index]}',
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
            ref.read(_selectedTilawatSurahProvider.notifier).state = suraNumber;
          },
        );
      },
    );
  }

  Widget _buildAyahList(WidgetRef ref) {
    final selectedSurah = ref.watch(_selectedTilawatSurahProvider);
    final ayahCounts = ref.watch(ayahCountsProvider);

    if (selectedSurah < 1 || selectedSurah > 114) return const SizedBox();

    final totalAyahs = ayahCounts[selectedSurah - 1];

    return ScrollablePositionedList.separated(
      itemScrollController: _ayahScrollController,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: Theme.of(context).dividerColor),
      itemCount: totalAyahs,
      itemBuilder: (context, index) {
        final ayahNumber = index + 1;

        return ListTile(
          title: Center(
            child: Text(
              _toBengaliNumber(ayahNumber),
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).textTheme.bodyLarge?.color,
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
    // Close the drawer first
    Scaffold.of(context).closeDrawer();

    if (suraNumber == widget.currentSuraNumber) {
      // Same sura — just pop and re-navigate to refresh with the new ayah
      Navigator.pop(context);
      context.push('/qurans/tilawat?sura=$suraNumber&ayah=$ayahNumber');
    } else {
      // Different sura — navigate
      Future.delayed(const Duration(milliseconds: 200), () async {
        if (context.canPop()) context.pop();
        await Future.delayed(const Duration(milliseconds: 50));
        context.push('/qurans/tilawat?sura=$suraNumber&ayah=$ayahNumber');
      });
    }
  }
}

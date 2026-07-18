import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/value_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:native_app/theme/app_colors.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../../providers/ayah_highlight_providers.dart';

final selectedNavigationSurahProvider = valueProvider<int>(1);

final selectedNavigationAyahProvider = valueProvider<int?>(null);

class SurahNavigationView extends ConsumerStatefulWidget {
  const SurahNavigationView({super.key});

  @override
  ConsumerState<SurahNavigationView> createState() =>
      _SurahNavigationViewState();
}

class _SurahNavigationViewState extends ConsumerState<SurahNavigationView> {
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
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final mappingsAsync = ref.watch(quranMappingsProvider);
    if (mappingsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (mappingsAsync.hasError) {
      return Center(
        child: Text(
          'Error loading Surah/Ayah data',
          style: TextStyle(fontSize: 14.sp),
        ),
      );
    }

    final suraPageMapping = ref.watch(suraPageMappingProvider);
    final selectedAyah = ref.watch(selectedAyahProvider);

    if (!_isInitialStateSet && suraPageMapping.isNotEmpty) {
      int currentSurah = selectedAyah?.suraNumber ?? 1;
      int? currentAyah = selectedAyah?.ayahNumber;

      if (currentAyah == null) {
        final currentPage = ref.read(currentPageProvider) + 1;
        for (int i = 1; i <= 114; i++) {
          if (suraPageMapping.containsKey(i) &&
              suraPageMapping[i]! <= currentPage) {
            currentSurah = i;
          } else {
            break;
          }
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(selectedNavigationSurahProvider.notifier).set(currentSurah);
          ref.read(selectedNavigationAyahProvider.notifier).set(currentAyah);

          _surahScrollController.jumpTo(index: currentSurah - 1);

          if (currentAyah != null) {
            _ayahScrollController.jumpTo(index: currentAyah - 1);
          }
        }
      });
      _isInitialStateSet = true;
    }

    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Row(
            children: [
              Expanded(flex: 3, child: _buildSurahList(ref)),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: appColors.divider,
              ),
              Expanded(flex: 2, child: _buildRightPane(ref)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 14.0 : 16.sp;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final appBarBg = appColors.drawerHeaderBg;
    final appBarFg = appColors.appBarText;

    return Container(
      color: appBarBg,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'সূরা',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appBarFg,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'আয়াত',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appBarFg,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahList(WidgetRef ref) {
    final selectedSurah = ref.watch(selectedNavigationSurahProvider);
    final suraNames = ref.watch(suraNamesProvider);
    final selectedAyah = ref.watch(selectedAyahProvider);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 14.0 : 16.sp;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassicTheme = appColors.highlight == AppColors.highlightClassic &&
        appColors.active == AppColors.activeClassic;
    final selectedTextColor =
        isClassicTheme ? appColors.primaryText : appColors.active;

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
          tileColor: isSelected ? appColors.highlight : null,
          title: Text(
            '${toBengaliNumber(suraNumber)}. ${suraNames[index]}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? selectedTextColor : appColors.primaryText,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          onTap: () {
            ref.read(selectedNavigationSurahProvider.notifier).set(suraNumber);

            ref.read(selectedNavigationAyahProvider.notifier).set(selectedAyah?.ayahNumber);
          },
        );
      },
    );
  }

  Widget _buildRightPane(WidgetRef ref) {
    final selectedSurah = ref.watch(selectedNavigationSurahProvider);
    final selectedAyah = ref.watch(selectedNavigationAyahProvider);
    final ayahCounts = ref.watch(ayahCountsProvider);
    final ayahPageMapping = ref.watch(ayahPageMappingProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 12.0 : 14.sp;
    final isClassicTheme = appColors.highlight == AppColors.highlightClassic &&
        appColors.active == AppColors.activeClassic;
    final selectedTextColor =
        isClassicTheme ? appColors.primaryText : appColors.active;

    final totalAyahs = ayahCounts[selectedSurah - 1];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _ayahScrollController.isAttached) {
        final currentAyah = ref.read(selectedAyahProvider)?.ayahNumber;
        if (currentAyah != null) {
          _ayahScrollController.jumpTo(index: currentAyah - 1);
        }
      }
    });

    return ScrollablePositionedList.separated(
      itemScrollController: _ayahScrollController,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: appColors.divider),
      itemCount: totalAyahs,
      itemBuilder: (context, index) {
        final ayahNumber = index + 1;
        final isSelected =
            selectedSurah == selectedSurah && ayahNumber == selectedAyah;

        return ListTile(
          tileColor: isSelected ? appColors.highlight : null,
          title: Center(
            child: Text(
              toBengaliNumber(ayahNumber),
              style: TextStyle(
                fontSize: fontSize,
                color: isSelected ? selectedTextColor : appColors.primaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          onTap: () {
            final targetPage = ayahPageMapping[(selectedSurah, ayahNumber)];
            if (targetPage != null) {
              // Select Ayah FIRST
              ref
                  .read(selectedAyahProvider.notifier)
                  .selectByNavigation(selectedSurah, ayahNumber);
              // THEN Navigate
              ref.read(navigateToPageCommandProvider.notifier).set(targetPage);
              Scaffold.of(context).closeDrawer();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Page data not found for this Ayah'),
                ),
              );
            }
          },
        );
      },
    );
  }
}

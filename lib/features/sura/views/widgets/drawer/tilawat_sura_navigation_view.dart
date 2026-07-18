import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/value_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

final _selectedTilawatSurahProvider = valueProvider<int>(1);

class TilawatSuraNavigationView extends ConsumerStatefulWidget {
  final int currentSuraNumber;
  final int currentAyahNumber;
  final String returnTo;

  const TilawatSuraNavigationView({
    super.key,
    required this.currentSuraNumber,
    required this.currentAyahNumber,
    required this.returnTo,
  });

  @override
  ConsumerState<TilawatSuraNavigationView> createState() =>
      _TilawatSuraNavigationViewState();
}

class _TilawatSuraNavigationViewState
    extends ConsumerState<TilawatSuraNavigationView> {
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
      ref.read(_selectedTilawatSurahProvider.notifier).set(widget.currentSuraNumber);
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
                color: Theme.of(context).extension<AppThemeColors>()!.divider,
              ),
              Expanded(flex: 2, child: _buildAyahList(ref)),
            ],
          ),
        ),
      ],
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
              'সূরা',
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
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final selectedBg = appColors.highlight;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final selectedFg = isClassic ? appColors.appBarBg : appColors.primaryText;

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
            ref.read(_selectedTilawatSurahProvider.notifier).set(suraNumber);
          },
        );
      },
    );
  }

  Widget _buildAyahList(WidgetRef ref) {
    final selectedSurah = ref.watch(_selectedTilawatSurahProvider);
    final ayahCounts = ref.watch(ayahCountsProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final selectedFg = isClassic ? appColors.appBarBg : appColors.primaryText;

    if (selectedSurah < 1 || selectedSurah > 114) return const SizedBox();

    final totalAyahs = ayahCounts[selectedSurah - 1];

    return ScrollablePositionedList.separated(
      itemScrollController: _ayahScrollController,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) =>
          Divider(height: 1.h, color: appColors.divider),
      itemCount: totalAyahs,
      itemBuilder: (context, index) {
        final ayahNumber = index + 1;

        return ListTile(
          tileColor: ayahNumber == widget.currentAyahNumber &&
                  selectedSurah == widget.currentSuraNumber
              ? appColors.highlight
              : null,
          title: Center(
            child: Text(
              _toBengaliNumber(ayahNumber),
              style: TextStyle(
                fontSize: 14.sp,
                color: ayahNumber == widget.currentAyahNumber &&
                        selectedSurah == widget.currentSuraNumber
                    ? selectedFg
                    : appColors.primaryText,
                fontWeight: ayahNumber == widget.currentAyahNumber &&
                        selectedSurah == widget.currentSuraNumber
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          onTap: () {
            _navigateToTilawat(context, selectedSurah, ayahNumber);
          },
        );
      },
    );
  }

  void _navigateToTilawat(
    BuildContext context,
    int suraNumber,
    int ayahNumber,
  ) {
    Scaffold.of(context).closeDrawer();

    if (suraNumber == widget.currentSuraNumber &&
        ayahNumber == widget.currentAyahNumber) {
      return;
    }

    Future.delayed(const Duration(milliseconds: 200), () async {
      if (!context.mounted) return;
      if (context.canPop()) context.pop();
      await Future.delayed(const Duration(milliseconds: 50));
      if (!context.mounted) return;
      context.push(
        buildTilawatRoute(
          suraNumber: suraNumber,
          ayahNumber: ayahNumber,
          returnTo: widget.returnTo,
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/value_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';

final selectedSuraNavSurahProvider = valueProvider<int>(1);
final selectedSuraNavAyahProvider = valueProvider<int?>(null);

class SuraNavigationTabView extends ConsumerStatefulWidget {
  final int currentSuraNumber;
  final String returnTo;

  const SuraNavigationTabView({
    super.key,
    required this.currentSuraNumber,
    required this.returnTo,
  });

  @override
  ConsumerState<SuraNavigationTabView> createState() =>
      _SuraNavigationTabViewState();
}

class _SuraNavigationTabViewState extends ConsumerState<SuraNavigationTabView> {
  final ItemScrollController _surahScrollController = ItemScrollController();
  final ItemScrollController _ayahScrollController = ItemScrollController();
  bool _isInitialStateSet = false;

  String _toBengaliNumber(int number) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((d) => bn[int.parse(d)]).join();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialStateSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(selectedSuraNavSurahProvider.notifier).set(widget.currentSuraNumber);
        ref.read(selectedSuraNavAyahProvider.notifier).set(null);
        if (_surahScrollController.isAttached) {
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
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(flex: 2, child: _buildAyahList(ref)),
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
    final selectedSurah = ref.watch(selectedSuraNavSurahProvider);
    final suraNames = ref.watch(suraNamesProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final selectedBg = appColors.highlight;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final selectedFg = isClassic ? appColors.appBarBg : appColors.primaryText;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 14.0 : 16.sp;

    return ScrollablePositionedList.separated(
      itemScrollController: _surahScrollController,
      padding: EdgeInsets.zero,
      itemCount: 114,
      separatorBuilder: (context, _) =>
          Divider(height: 1.h, color: appColors.divider),
      itemBuilder: (context, index) {
        final suraNumber = index + 1;
        final isSelected = suraNumber == selectedSurah;

        return ListTile(
          tileColor: isSelected ? selectedBg : null,
          title: Text(
            '${_toBengaliNumber(suraNumber)}. ${suraNames[index]}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? selectedFg
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          onTap: () {
            ref.read(selectedSuraNavSurahProvider.notifier).set(suraNumber);
            ref.read(selectedSuraNavAyahProvider.notifier).set(null);
          },
        );
      },
    );
  }

  Widget _buildAyahList(WidgetRef ref) {
    final selectedSurah = ref.watch(selectedSuraNavSurahProvider);
    final selectedAyah = ref.watch(selectedSuraNavAyahProvider);
    final ayahCounts = ref.watch(ayahCountsProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final selectedBg = appColors.highlight;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final selectedFg = isClassic ? appColors.appBarBg : appColors.primaryText;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 12.0 : 14.sp;

    if (selectedSurah < 1 || selectedSurah > 114) return const SizedBox();
    final totalAyahs = ayahCounts[selectedSurah - 1];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_ayahScrollController.isAttached) return;
      if (selectedAyah != null) {
        _ayahScrollController.jumpTo(index: selectedAyah - 1);
      }
    });

    return ScrollablePositionedList.separated(
      itemScrollController: _ayahScrollController,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, _) =>
          Divider(height: 1.h, color: appColors.divider),
      itemCount: totalAyahs,
      itemBuilder: (context, index) {
        final ayahNumber = index + 1;
        final isSelected = ayahNumber == selectedAyah;

        return ListTile(
          tileColor: isSelected ? selectedBg : null,
          title: Center(
            child: Text(
              _toBengaliNumber(ayahNumber),
              style: TextStyle(
                fontSize: fontSize,
                color: isSelected
                    ? selectedFg
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          onTap: () => _onAyahSelected(context, selectedSurah, ayahNumber),
        );
      },
    );
  }

  void _onAyahSelected(BuildContext context, int suraNumber, int ayahNumber) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('last_read_sura', suraNumber);
      prefs.setInt('last_read_ayah_index', ayahNumber - 1);
    });

    Scaffold.of(context).closeDrawer();

    if (suraNumber == widget.currentSuraNumber) {
      ref.read(suraScrollCommandProvider.notifier).set(ScrollCommand(
        suraNumber: suraNumber,
        scrollIndex: ayahNumber - 1,
      ));
      return;
    }

    Future.delayed(const Duration(milliseconds: 200), () async {
      if (!context.mounted) return;
      if (context.canPop()) context.pop();
      await Future.delayed(const Duration(milliseconds: 50));
      if (!context.mounted) return;
      context.push(
        buildSuraRoute(
          suraNumber: suraNumber,
          scrollIndex: ayahNumber - 1,
          returnTo: widget.returnTo,
        ),
      );
    });
  }
}

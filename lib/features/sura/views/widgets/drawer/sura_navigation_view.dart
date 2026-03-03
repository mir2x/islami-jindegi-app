import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';

final selectedSuraNavSurahProvider = StateProvider<int>((_) => 1);
final selectedSuraNavAyahProvider = StateProvider<int?>((_) => null);

class SuraNavigationTabView extends ConsumerStatefulWidget {
  final int currentSuraNumber;

  const SuraNavigationTabView({super.key, required this.currentSuraNumber});

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
        ref.read(selectedSuraNavSurahProvider.notifier).state =
            widget.currentSuraNumber;
        ref.read(selectedSuraNavAyahProvider.notifier).state = null;
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
    final appBarTheme = Theme.of(context).appBarTheme;
    final appBarBg =
        appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final appBarFg =
        appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onSurface;

    return Container(
      color: appBarBg,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'সুরা',
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 14.0 : 16.sp;

    return ScrollablePositionedList.separated(
      itemScrollController: _surahScrollController,
      padding: EdgeInsets.zero,
      itemCount: 114,
      separatorBuilder: (context, _) =>
          Divider(height: 1.h, color: Theme.of(context).dividerColor),
      itemBuilder: (context, index) {
        final suraNumber = index + 1;
        final isSelected = suraNumber == selectedSurah;

        return ListTile(
          tileColor: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
          title: Text(
            '${_toBengaliNumber(suraNumber)}. ${suraNames[index]}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          onTap: () {
            ref.read(selectedSuraNavSurahProvider.notifier).state = suraNumber;
            ref.read(selectedSuraNavAyahProvider.notifier).state = null;
          },
        );
      },
    );
  }

  Widget _buildAyahList(WidgetRef ref) {
    final selectedSurah = ref.watch(selectedSuraNavSurahProvider);
    final selectedAyah = ref.watch(selectedSuraNavAyahProvider);
    final ayahCounts = ref.watch(ayahCountsProvider);
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
          Divider(height: 1.h, color: Theme.of(context).dividerColor),
      itemCount: totalAyahs,
      itemBuilder: (context, index) {
        final ayahNumber = index + 1;
        final isSelected = ayahNumber == selectedAyah;

        return ListTile(
          tileColor: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
          title: Center(
            child: Text(
              _toBengaliNumber(ayahNumber),
              style: TextStyle(
                fontSize: fontSize,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
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
      ref.read(suraScrollCommandProvider.notifier).state = ScrollCommand(
        suraNumber: suraNumber,
        scrollIndex: ayahNumber - 1,
      );
      return;
    }

    Future.delayed(const Duration(milliseconds: 200), () async {
      await QR.back();
      await Future.delayed(const Duration(milliseconds: 50));
      QR.to('/qurans/sura/$suraNumber?scroll=${ayahNumber - 1}');
    });
  }
}

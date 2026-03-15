import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart'
    show paraStarts;
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';

final selectedTilawatDrawerParaProvider = StateProvider<int>((_) => 1);

class TilawatParaNavigationView extends ConsumerStatefulWidget {
  final int currentSuraNumber;
  final int currentAyahNumber;
  final String returnTo;

  const TilawatParaNavigationView({
    super.key,
    required this.currentSuraNumber,
    required this.currentAyahNumber,
    required this.returnTo,
  });

  @override
  ConsumerState<TilawatParaNavigationView> createState() =>
      _TilawatParaNavigationViewState();
}

class _TilawatParaNavigationViewState
    extends ConsumerState<TilawatParaNavigationView> {
  bool _isInitialStateSet = false;

  String _toBengaliNumber(int number) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((d) => bn[int.parse(d)]).join();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialStateSet) {
      final initialPara = _inferParaFromCurrentPosition(
        widget.currentSuraNumber,
        widget.currentAyahNumber,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(selectedTilawatDrawerParaProvider.notifier).state =
              initialPara;
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
              Expanded(flex: 1, child: _buildParaList(ref)),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: Theme.of(context).extension<AppThemeColors>()!.divider,
              ),
              Expanded(flex: 1, child: _buildStartList(ref)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant TilawatParaNavigationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSuraNumber != widget.currentSuraNumber ||
        oldWidget.currentAyahNumber != widget.currentAyahNumber) {
      final para = _inferParaFromCurrentPosition(
        widget.currentSuraNumber,
        widget.currentAyahNumber,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(selectedTilawatDrawerParaProvider.notifier).state = para;
        }
      });
    }
  }

  int _inferParaFromCurrentPosition(int currentSura, int currentAyah) {
    int para = 1;
    for (int i = 0; i < paraStarts.length; i++) {
      final (sura, ayah) = paraStarts[i];
      if (sura < currentSura || (sura == currentSura && ayah <= currentAyah)) {
        para = i + 1;
      } else {
        break;
      }
    }
    return para;
  }

  Widget _buildHeader(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 14.0 : 16.sp;
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final headerBg = appColors.drawerHeaderBg;
    final headerFg = appColors.appBarText;

    return Container(
      color: headerBg,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'পারা',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: headerFg,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'শুরু',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: headerFg,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParaList(WidgetRef ref) {
    final selectedPara = ref.watch(selectedTilawatDrawerParaProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final selectedBg = appColors.highlight;
    final selectedFg = appColors.primaryText;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 14.0 : 16.sp;

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 30,
      separatorBuilder: (context, _) =>
          Divider(height: 1.h, color: appColors.divider),
      itemBuilder: (context, index) {
        final paraNumber = index + 1;
        final isSelected = paraNumber == selectedPara;

        return ListTile(
          tileColor: isSelected ? selectedBg : null,
          title: Center(
            child: Text(
              _toBengaliNumber(paraNumber),
              style: TextStyle(
                fontSize: fontSize,
                color: isSelected
                    ? selectedFg
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          onTap: () {
            ref.read(selectedTilawatDrawerParaProvider.notifier).state =
                paraNumber;
          },
        );
      },
    );
  }

  Widget _buildStartList(WidgetRef ref) {
    final selectedPara = ref.watch(selectedTilawatDrawerParaProvider);
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final selectedBg = appColors.highlight;
    final selectedFg = appColors.primaryText;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final fontSize = isLandscape ? 12.0 : 14.sp;
    final (suraNumber, ayahNumber) = paraStarts[selectedPara - 1];

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 1,
      separatorBuilder: (context, _) =>
          Divider(height: 1.h, color: appColors.divider),
      itemBuilder: (context, _) {
        return ListTile(
          tileColor: selectedBg,
          title: Center(
            child: Text(
              '${_toBengaliNumber(suraNumber)}:${_toBengaliNumber(ayahNumber)}',
              style: TextStyle(
                fontSize: fontSize,
                color: selectedFg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () => _navigateToAyah(context, suraNumber, ayahNumber),
        );
      },
    );
  }

  void _navigateToAyah(BuildContext context, int suraNumber, int ayahNumber) {
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

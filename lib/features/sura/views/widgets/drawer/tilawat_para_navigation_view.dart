import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart'
    show paraStarts;
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/shared/quran_data.dart';
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
        Expanded(child: _buildParaList(ref)),
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
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Text(
        'পারা',
        style: TextStyle(
          color: headerFg,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
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
    final titleFontSize = isLandscape ? 14.0 : 16.sp;
    final subtitleFontSize = isLandscape ? 11.0 : 12.sp;

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: paraStarts.length,
      separatorBuilder: (context, _) =>
          Divider(height: 1.h, color: appColors.divider),
      itemBuilder: (context, index) {
        final paraNumber = index + 1;
        final isSelected = paraNumber == selectedPara;
        final (suraNumber, ayahNumber) = paraStarts[index];
        final suraName = suraNames[suraNumber - 1];

        return ListTile(
          tileColor: isSelected ? selectedBg : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          title: Text(
            'পারা ${_toBengaliNumber(paraNumber)}',
            style: TextStyle(
              fontSize: titleFontSize,
              color: isSelected ? selectedFg : appColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              'সূরা $suraName • আয়াত ${_toBengaliNumber(ayahNumber)}',
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: isSelected
                    ? selectedFg.withValues(alpha: 0.82)
                    : appColors.secondaryText,
              ),
            ),
          ),
          onTap: () {
            ref.read(selectedTilawatDrawerParaProvider.notifier).state =
                paraNumber;
            _navigateToAyah(context, suraNumber, ayahNumber);
          },
          minVerticalPadding: 0,
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

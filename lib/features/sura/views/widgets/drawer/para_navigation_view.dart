import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/quran/providers/ayah_highlight_providers.dart'
    show paraStarts;
import 'package:native_app/features/sura/providers/sura_providers.dart';
import 'package:native_app/theme/app_theme_color.dart';

final selectedDrawerParaProvider = StateProvider<int>((_) => 1);

class SuraParaNavigationView extends ConsumerStatefulWidget {
  final int currentSuraNumber;

  const SuraParaNavigationView({super.key, required this.currentSuraNumber});

  @override
  ConsumerState<SuraParaNavigationView> createState() =>
      _SuraParaNavigationViewState();
}

class _SuraParaNavigationViewState
    extends ConsumerState<SuraParaNavigationView> {
  bool _isInitialStateSet = false;

  String _toBengaliNumber(int number) {
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return number.toString().split('').map((d) => bn[int.parse(d)]).join();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialStateSet) {
      final initialPara = _inferParaFromCurrentSura(widget.currentSuraNumber);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(selectedDrawerParaProvider.notifier).state = initialPara;
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
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(flex: 1, child: _buildStartList(ref)),
            ],
          ),
        ),
      ],
    );
  }

  int _inferParaFromCurrentSura(int currentSura) {
    int para = 1;
    for (int i = 0; i < paraStarts.length; i++) {
      final (sura, _) = paraStarts[i];
      if (sura <= currentSura) {
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
    final appBarBg = appColors.drawerHeaderBg;
    final appBarFg = appColors.appBarText;

    return Container(
      color: appBarBg,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'পারা',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appBarFg,
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

  Widget _buildParaList(WidgetRef ref) {
    final selectedPara = ref.watch(selectedDrawerParaProvider);
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
            ref.read(selectedDrawerParaProvider.notifier).state = paraNumber;
          },
        );
      },
    );
  }

  Widget _buildStartList(WidgetRef ref) {
    final selectedPara = ref.watch(selectedDrawerParaProvider);
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

    if (suraNumber == widget.currentSuraNumber) {
      ref.read(suraScrollCommandProvider.notifier).state = ScrollCommand(
        suraNumber: suraNumber,
        scrollIndex: ayahNumber - 1,
      );
      return;
    }

    Future.delayed(const Duration(milliseconds: 200), () async {
      if (!context.mounted) return;
      if (context.canPop()) context.pop();
      await Future.delayed(const Duration(milliseconds: 50));
      if (!context.mounted) return;
      context.push('/qurans/sura/$suraNumber?scroll=${ayahNumber - 1}');
    });
  }
}

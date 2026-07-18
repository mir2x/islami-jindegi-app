import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/value_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/features/sura/views/widgets/drawer/bookmark_navigation_view.dart';
import 'package:native_app/features/sura/views/widgets/drawer/para_navigation_view.dart';
import 'package:native_app/features/sura/views/widgets/drawer/sura_navigation_view.dart';
import 'package:native_app/theme/app_theme_color.dart';

final suraDrawerTabIndexProvider = valueProvider<int>(0);

class SuraSideDrawer extends ConsumerStatefulWidget {
  final int currentSuraNumber;
  final int currentAyahNumber;
  final String returnTo;

  const SuraSideDrawer({
    super.key,
    required this.currentSuraNumber,
    required this.currentAyahNumber,
    required this.returnTo,
  });

  @override
  ConsumerState<SuraSideDrawer> createState() => _SuraSideDrawerState();
}

class _SuraSideDrawerState extends ConsumerState<SuraSideDrawer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: ref.read(suraDrawerTabIndexProvider),
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(suraDrawerTabIndexProvider.notifier).set(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topInset = media.padding.top + kToolbarHeight;
    final bottomInset = kBottomNavigationBarHeight + media.padding.bottom;

    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final appBarBg = appColors.drawerHeaderBg;
    final appBarFg = appColors.appBarText;
    final indicatorColor = appColors.highlight;
    final isClassic = appColors.primary == AppThemeColors.classic.primary &&
        appColors.appBarBg == AppThemeColors.classic.appBarBg;
    final selectedTabTextColor = isClassic ? appColors.appBarBg : appBarFg;
    final unselectedTabTextColor = isClassic
        ? appBarFg.withValues(alpha: 0.78)
        : appBarFg.withValues(alpha: 0.72);

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
        child: SizedBox(
          width: 250.w,
          child: Material(
            elevation: 0,
            color: appColors.drawerBg,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(22.r),
                bottomRight: Radius.circular(22.r),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SuraNavigationTabView(
                        currentSuraNumber: widget.currentSuraNumber,
                        returnTo: widget.returnTo,
                      ),
                      SuraParaNavigationView(
                        currentSuraNumber: widget.currentSuraNumber,
                        currentAyahNumber: widget.currentAyahNumber,
                        returnTo: widget.returnTo,
                      ),
                      SuraBookmarkNavigationView(
                        currentSuraNumber: widget.currentSuraNumber,
                        returnTo: widget.returnTo,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: appBarBg,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: selectedTabTextColor,
                    dividerColor: appBarBg.withValues(alpha: 0),
                    unselectedLabelColor: unselectedTabTextColor,
                    indicator: BoxDecoration(
                      color: indicatorColor,
                      borderRadius: BorderRadius.zero,
                    ),
                    indicatorWeight: 0,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'সূরা'),
                      Tab(text: 'পারা'),
                      Tab(text: 'বুকমার্ক'),
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
}

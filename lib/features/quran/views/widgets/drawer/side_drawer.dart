import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/features/quran/views/widgets/drawer/bookmark_navigation_view.dart';
import 'package:native_app/features/quran/views/widgets/drawer/para_navigation_view.dart';
import 'package:native_app/features/quran/views/widgets/drawer/sura_navigation_view.dart';
import 'package:native_app/theme/app_colors.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../../providers/ayah_highlight_providers.dart';

final drawerTabIndexProvider = StateProvider<int>((_) => 0);

class SideDrawer extends ConsumerStatefulWidget {
  const SideDrawer({super.key});

  @override
  ConsumerState<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends ConsumerState<SideDrawer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: ref.read(drawerTabIndexProvider),
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(drawerTabIndexProvider.notifier).state = _tabController.index;
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
    return Align(
      alignment: Alignment.topLeft,
      child: Builder(
        builder: (context) {
          final media = MediaQuery.of(context);
          final bool isLandscape = media.orientation == Orientation.landscape;
          final double topInset =
              media.padding.top + (isLandscape ? 52.0 : 64.0);
          final double bottomInset =
              media.padding.bottom + (isLandscape ? 50.0 : 64.0.h);

          final mappingsAsync = ref.watch(quranMappingsProvider);
          final suraMapping = ref.watch(suraPageMappingProvider);
          final paraPageRanges = ref.watch(paraPageRangesProvider);

          final bool isLoading = mappingsAsync.isLoading;
          final bool hasError = mappingsAsync.hasError;
          final bool isDataReady = !isLoading &&
              !hasError &&
              suraMapping.isNotEmpty &&
              paraPageRanges.isNotEmpty;

          Widget tabContent;
          if (isLoading) {
            tabContent = const Center(child: CircularProgressIndicator());
          } else if (hasError) {
            tabContent = const Center(child: Text('Error loading data'));
          } else if (!isDataReady) {
            tabContent = const Center(child: Text('Processing data...'));
          } else {
            tabContent = TabBarView(
              controller: _tabController,
              children: const [
                SurahNavigationView(),
                ParaNavigationView(),
                BookmarkNavigationView(),
              ],
            );
          }

          return Padding(
            padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
            child: SizedBox(
              width: 250.w,
              child: Builder(
                builder: (ctx) {
                  final c = Theme.of(ctx).extension<AppThemeColors>()!;
                  final bgDark =
                      ThemeData.estimateBrightnessForColor(c.drawerBg) ==
                          Brightness.dark;
                  final textDark =
                      ThemeData.estimateBrightnessForColor(c.primaryText) ==
                          Brightness.dark;
                  final isClassicTheme =
                      c.highlight == AppColors.highlightClassic &&
                          c.appBarText == AppColors.appBarTextClassic;
                  final contentBg =
                      (bgDark && textDark) ? c.surfaceBg : c.drawerBg;
                  final selectedTabLabelColor =
                      isClassicTheme ? c.primaryText : c.appBarText;
                  return Material(
                    elevation: 0,
                    color: contentBg,
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
                          child: tabContent,
                        ),
                        Builder(
                          builder: (context) {
                            final appColors =
                                Theme.of(context).extension<AppThemeColors>()!;
                            final appBarBg = appColors.drawerHeaderBg;
                            final appBarFg = appColors.appBarText;
                            final indicatorColor = appColors.highlight;
                            return Container(
                              color: appBarBg,
                              child: TabBar(
                                controller: _tabController,
                                labelColor: selectedTabLabelColor,
                                dividerColor: appBarBg.withValues(alpha: 0),
                                unselectedLabelColor:
                                    appBarFg.withValues(alpha: 0.72),
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
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

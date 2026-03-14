import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/features/quran/views/widgets/drawer/bookmark_navigation_view.dart';
import 'package:native_app/features/quran/views/widgets/drawer/para_navigation_view.dart';
import 'package:native_app/features/quran/views/widgets/drawer/sura_navigation_view.dart';
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
          final bool isDataReady =
              !isLoading && !hasError && suraMapping.isNotEmpty && paraPageRanges.isNotEmpty;

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
              children: [
                const SurahNavigationView(),
                const ParaNavigationView(),
                const BookmarkNavigationView(),
              ],
            );
          }

          return Padding(
            padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
            child: SizedBox(
              width: 250.w,
              child: Material(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      child: tabContent,
                    ),
                    Builder(builder: (context) {
                      final appColors =
                          Theme.of(context).extension<AppThemeColors>()!;
                      final colorScheme = Theme.of(context).colorScheme;
                      final isLight = colorScheme.brightness == Brightness.light;
                      final appBarBg = isLight ? appColors.surfaceBg : appColors.appBarBg;
                      final appBarFg = isLight ? appColors.secondaryText : appColors.appBarText;
                      final indicatorColor = isLight
                          ? appColors.divider.withOpacity(0.7)
                          : colorScheme.primary.withOpacity(0.3);
                      return Container(
                        color: appBarBg,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: appBarFg,
                          dividerColor: appBarBg.withValues(alpha: 0),
                          unselectedLabelColor: appBarFg.withOpacity(0.7),
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
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

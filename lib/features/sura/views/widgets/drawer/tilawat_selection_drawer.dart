import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/features/sura/views/widgets/drawer/tilawat_bookmark_navigation_view.dart';
import 'package:native_app/features/sura/views/widgets/drawer/tilawat_para_navigation_view.dart';
import 'package:native_app/features/sura/views/widgets/drawer/tilawat_sura_navigation_view.dart';
import 'package:native_app/theme/app_theme_color.dart';

final tilawatDrawerTabIndexProvider = StateProvider<int>((_) => 0);

class TilawatSelectionDrawer extends ConsumerStatefulWidget {
  final int currentSuraNumber;
  final int currentAyahNumber;
  final String returnTo;

  const TilawatSelectionDrawer({
    super.key,
    required this.currentSuraNumber,
    required this.currentAyahNumber,
    required this.returnTo,
  });

  @override
  ConsumerState<TilawatSelectionDrawer> createState() =>
      _TilawatSelectionDrawerState();
}

class _TilawatSelectionDrawerState extends ConsumerState<TilawatSelectionDrawer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: ref.read(tilawatDrawerTabIndexProvider),
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(tilawatDrawerTabIndexProvider.notifier).state =
            _tabController.index;
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
    final bottomInset = media.padding.bottom;

    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final headerBg = appColors.drawerHeaderBg;
    final headerFg = appColors.appBarText;
    final indicatorColor = appColors.highlight;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
        child: SizedBox(
          width: 280.w,
          child: Material(
            elevation: 16,
            color: appColors.drawerBg,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TilawatSuraNavigationView(
                        currentSuraNumber: widget.currentSuraNumber,
                        currentAyahNumber: widget.currentAyahNumber,
                        returnTo: widget.returnTo,
                      ),
                      TilawatParaNavigationView(
                        currentSuraNumber: widget.currentSuraNumber,
                        currentAyahNumber: widget.currentAyahNumber,
                        returnTo: widget.returnTo,
                      ),
                      TilawatBookmarkNavigationView(
                        currentSuraNumber: widget.currentSuraNumber,
                        returnTo: widget.returnTo,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: headerBg,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: headerFg,
                    dividerColor: headerBg.withValues(alpha: 0),
                    unselectedLabelColor: headerFg.withValues(alpha: 0.72),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/features/sura_list/views/widgets/bookmark_list.dart';
import 'package:native_app/features/sura_list/views/widgets/para_list.dart';
import 'package:native_app/features/sura_list/views/widgets/sura_list_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import '../models/sources/sura_information.dart';
import '../providers/sura_list_providers.dart';

class SuraListPage extends ConsumerStatefulWidget {
  const SuraListPage({super.key});

  @override
  ConsumerState<SuraListPage> createState() => _SuraListPageState();
}

class _SuraListPageState extends ConsumerState<SuraListPage>
    with SingleTickerProviderStateMixin {
  final ItemScrollController _itemScrollController = ItemScrollController();
  int? _highlightedSuraNumber;
  late TabController _tabController;
  int? _handlingSuraNumber;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the lastViewedSuraProvider for changes
    ref.listen<int?>(lastViewedSuraProvider, (previous, next) {
      if (next != null) {
        _handleLastViewedSura(next);
      }
    });

    // Also check on first build in case the value is already set
    final lastViewedSura = ref.watch(lastViewedSuraProvider);
    if (lastViewedSura != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleLastViewedSura(lastViewedSura);
      });
    }

    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isClassic = colors.primary == AppThemeColors.classic.primary &&
        colors.appBarBg == AppThemeColors.classic.appBarBg;
    final selectedTabTextColor = colors.appBarText;
    final unselectedTabTextColor =
        colors.appBarText.withValues(alpha: isClassic ? 0.64 : 0.64);

    return AppScaffold(
      onBackPressed: () async => context.go('/qurans'),
      title: const Text('সকল সূরা'),
      extraActions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push(buildSearchRoute()),
        ),
      ],
      body: Column(
        children: [
          Container(
            color: colors.appBarBg,
            child: TabBar(
              controller: _tabController,
              labelStyle: const TextStyle(
                wordSpacing: 3,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                wordSpacing: 3,
                fontSize: 16,
              ),
              indicator: BoxDecoration(
                color: isClassic
                    ? colors.appBarText.withValues(alpha: 0.18)
                    : colors.active.withValues(alpha: 0.28),
              ),
              dividerColor: colors.appBarBg.withValues(alpha: 0),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: selectedTabTextColor,
              unselectedLabelColor: unselectedTabTextColor,
              tabs: const [
                Tab(text: 'সূরা'),
                Tab(text: 'পারা'),
                Tab(text: 'বুকমার্ক'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ScrollablePositionedList.separated(
                  itemScrollController: _itemScrollController,
                  itemCount: allSuras.length,
                  itemBuilder: (context, index) {
                    final sura = allSuras[index];
                    return SuraListItem(
                      sura: sura,
                      isHighlighted: _highlightedSuraNumber == sura.number,
                      onTap: () {
                        setState(() {
                          _highlightedSuraNumber = null;
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 0.5,
                      indent: 16,
                      endIndent: 16,
                      color: colors.divider,
                    );
                  },
                ),
                const ParaList(),
                const BookmarkList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollAndHighlight(int suraNumber) {
    final scrollIndex = suraNumber - 1;

    if (!_itemScrollController.isAttached ||
        scrollIndex < 0 ||
        scrollIndex >= allSuras.length) {
      return;
    }

    _itemScrollController.scrollTo(
      index: scrollIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );

    // Trigger highlight animation after scroll completes
    Future.delayed(const Duration(milliseconds: 550), () {
      if (!mounted) return;
      setState(() {
        _highlightedSuraNumber = suraNumber;
      });
      if (ref.read(lastViewedSuraProvider) == suraNumber) {
        ref.read(lastViewedSuraProvider.notifier).set(null);
      }
      if (_handlingSuraNumber == suraNumber) {
        _handlingSuraNumber = null;
      }
    });
  }

  void _handleLastViewedSura(int suraNumber) {
    if (!mounted || _handlingSuraNumber == suraNumber) return;
    _handlingSuraNumber = suraNumber;

    if (_tabController.index != 0) {
      _tabController.animateTo(0);
    }

    _tryScrollAndHighlight(suraNumber);
  }

  void _tryScrollAndHighlight(int suraNumber, {int attempt = 0}) {
    if (!mounted || _handlingSuraNumber != suraNumber) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _handlingSuraNumber != suraNumber) return;

      if (_itemScrollController.isAttached) {
        _scrollAndHighlight(suraNumber);
        return;
      }

      if (attempt >= 12) {
        setState(() {
          _highlightedSuraNumber = suraNumber;
        });
        if (ref.read(lastViewedSuraProvider) == suraNumber) {
          ref.read(lastViewedSuraProvider.notifier).set(null);
        }
        _handlingSuraNumber = null;
        return;
      }

      Future.delayed(const Duration(milliseconds: 80), () {
        _tryScrollAndHighlight(suraNumber, attempt: attempt + 1);
      });
    });
  }
}

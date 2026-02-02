import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/features/sura_list/view/widgets/bookmark_list.dart';
import 'package:native_app/features/sura_list/view/widgets/para_list.dart';
import 'package:native_app/features/sura_list/view/widgets/sura_list_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../model/sources/sura_information.dart';
import '../viewmodel/sura_list_providers.dart';

class SuraListPage extends ConsumerStatefulWidget {
  const SuraListPage({super.key});

  @override
  ConsumerState<SuraListPage> createState() => _SuraListPageState();
}

class _SuraListPageState extends ConsumerState<SuraListPage>
    with SingleTickerProviderStateMixin {
  final ItemScrollController _itemScrollController = ItemScrollController();
  int? _highlightedSuraNumber;
  bool _hasHandledLastViewed = false;
  late TabController _tabController;

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
      if (next != null && !_hasHandledLastViewed) {
        _hasHandledLastViewed = true;
        // Switch to sura tab if not already there
        if (_tabController.index != 0) {
          _tabController.animateTo(0);
        }
        // Delay scroll to allow tab switch
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollAndHighlight(next);
        });
        // Clear the provider state after handling
        Future(() {
          ref.read(lastViewedSuraProvider.notifier).state = null;
        });
      }
    });

    // Also check on first build in case the value is already set
    final lastViewedSura = ref.watch(lastViewedSuraProvider);
    if (lastViewedSura != null && !_hasHandledLastViewed) {
      _hasHandledLastViewed = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_tabController.index != 0) {
          _tabController.animateTo(0);
        }
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollAndHighlight(lastViewedSura);
        });
        Future(() {
          ref.read(lastViewedSuraProvider.notifier).state = null;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'সকল সূরা',
          style: TextStyle(fontFamily: 'bangla/solaimanlipi'),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontFamily: 'bangla/solaimanlipi',
              wordSpacing: 3,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'bangla/solaimanlipi',
              wordSpacing: 3,
            fontSize: 16,
          ),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          tabs: const [
            Tab(text: 'সূরা'),
            Tab(text: 'পারা'),
            Tab(text: 'বুকমার্ক'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Sura List Tab
          ScrollablePositionedList.separated(
            itemScrollController: _itemScrollController,
            itemCount: allSuras.length,
            itemBuilder: (context, index) {
              final sura = allSuras[index];
              return SuraListItem(
                sura: sura,
                isHighlighted: _highlightedSuraNumber == sura.number,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              );
            },
          ),
          // Para Tab
          const ParaList(),
          // Bookmark Tab
          const BookmarkList(),
        ],
      ),
    );
  }

  void _scrollAndHighlight(int suraNumber) {
    final scrollIndex = suraNumber - 1;

    if (_itemScrollController.isAttached &&
        scrollIndex >= 0 &&
        scrollIndex < allSuras.length) {
      _itemScrollController.scrollTo(
        index: scrollIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );

      // Trigger highlight animation after scroll completes
      Future.delayed(const Duration(milliseconds: 550), () {
        if (mounted) {
          setState(() {
            _highlightedSuraNumber = suraNumber;
          });

          // Clear highlight after animation completes (800ms animation)
          Future.delayed(const Duration(milliseconds: 900), () {
            if (mounted) {
              setState(() {
                _highlightedSuraNumber = null;
                _hasHandledLastViewed = false;
              });
            }
          });
        }
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/sura/views/widgets/quran_page_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:native_app/shared/quran_data.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../models/tilawat_models.dart';
import '../../providers/tilawat_providers.dart';
import 'font_change_dialog.dart';
import 'drawer/tilawat_selection_drawer.dart';
import 'sura_app_bar.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';

class TilawatPage extends ConsumerStatefulWidget {
  final int initialSuraNumber;
  final int initialAyahNumber;
  final String returnTo;

  const TilawatPage({
    super.key,
    required this.initialSuraNumber,
    required this.initialAyahNumber,
    this.returnTo = suraListRoute,
  });

  @override
  ConsumerState<TilawatPage> createState() => _TilawatPageState();
}

class _TilawatPageState extends ConsumerState<TilawatPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _totalPages = 0;
  int _bottomVisibleIndex = 0;
  bool _nextSuraPromptShown = false;
  bool _prevSuraPromptShown = false;

  bool get _isAtEnd => _totalPages > 0 && _bottomVisibleIndex >= _totalPages - 1;

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    super.dispose();
  }

  void _onPositionsChanged() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final maxIndex =
        positions.map((p) => p.index).reduce((a, b) => a > b ? a : b);
    if (maxIndex != _bottomVisibleIndex) {
      setState(() {
        _bottomVisibleIndex = maxIndex;
      });
    }

    // Reset prompt flags when user scrolls away from the edges
    if (maxIndex < _totalPages - 1) {
      _nextSuraPromptShown = false;
    }
    if (positions.map((p) => p.index).reduce((a, b) => a < b ? a : b) > 0) {
      _prevSuraPromptShown = false;
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is OverscrollNotification) {
      final threshold = _totalPages <= 1 ? 0.0 : 12.0;
      if (notification.overscroll > threshold && _isAtEnd) {
        _showNextSuraPrompt();
      } else if (notification.overscroll < -threshold && _bottomVisibleIndex == 0) {
        _showPrevSuraPrompt();
      }
    }
    return false;
  }

  Future<void> _showNextSuraPrompt() async {
    if (_nextSuraPromptShown || widget.initialSuraNumber >= suraNames.length) {
      return;
    }

    _nextSuraPromptShown = true;
    final nextSuraNumber = widget.initialSuraNumber + 1;
    final nextSuraName = suraNames[nextSuraNumber - 1];
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.divider),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: colors.divider.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.primary.withValues(alpha: 0.94),
                          colors.secondary.withValues(alpha: 0.82),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      color: colors.appBarText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'সূরা শেষ হয়েছে',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'পরের সূরা $nextSuraName এ যেতে চান?',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.secondaryText,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('এখন না'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            if (!mounted || !context.mounted) return;
                            context.pushReplacement(
                              buildTilawatRoute(
                                suraNumber: nextSuraNumber,
                                ayahNumber: 1,
                                returnTo: widget.returnTo,
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'পরের সূরা ${nextSuraNumber.toBengaliDigit()}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _nextSuraPromptShown = false;
    });
  }

  Future<void> _showPrevSuraPrompt() async {
    if (_prevSuraPromptShown || widget.initialSuraNumber <= 1) return;

    _prevSuraPromptShown = true;
    final prevSuraNumber = widget.initialSuraNumber - 1;
    final prevSuraName = suraNames[prevSuraNumber - 1];
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.divider),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 6,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: colors.divider.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.primary.withValues(alpha: 0.94),
                          colors.secondary.withValues(alpha: 0.82),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(Icons.auto_stories_rounded, color: colors.appBarText),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'আগের সূরায় যাবেন?',
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'আগের সূরা $prevSuraName এ যেতে চান?',
                    style: textTheme.bodyLarge?.copyWith(color: colors.secondaryText, height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('এখন না'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            if (!mounted || !context.mounted) return;
                            context.pushReplacement(
                              buildTilawatRoute(
                                suraNumber: prevSuraNumber,
                                ayahNumber: 1,
                                returnTo: widget.returnTo,
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('আগের সূরা ${prevSuraNumber.toBengaliDigit()}'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _prevSuraPromptShown = false;
    });
  }

  int _findInitialPageIndex(List<QuranPage> surahPages) {
    for (int i = 0; i < surahPages.length; i++) {
      final page = surahPages[i];
      for (var content in page.content) {
        if (content.ayahs
            .any((ayah) => ayah.ayahNumber == widget.initialAyahNumber)) {
          return i;
        }
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final pagesAsync = ref.watch(quranPagesProvider(widget.initialSuraNumber));
    final suraName = 'সূরা ${suraNames[widget.initialSuraNumber - 1]}';

    return Scaffold(
      key: _scaffoldKey,
      appBar: SuraAppBar(
        title: suraName,
        suraNumber: widget.initialSuraNumber,
        currentAyahNumber: widget.initialAyahNumber,
        returnTo: widget.returnTo,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            tooltip: 'ফন্ট পরিবর্তন',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const FontChangeDialog(),
              );
            },
          ),
        ],
      ),
      drawer: TilawatSelectionDrawer(
        currentSuraNumber: widget.initialSuraNumber,
        currentAyahNumber: widget.initialAyahNumber,
        returnTo: widget.returnTo,
      ),
      body: pagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('পৃষ্ঠা লোড করা যায়নি:\n$err')),
        data: (surahPages) {
          if (surahPages.isEmpty) {
            return const Center(child: Text('কোন পৃষ্ঠা পাওয়া যায়নি।'));
          }

          _totalPages = surahPages.length;

          final initialIndex = _findInitialPageIndex(surahPages);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_itemScrollController.isAttached) {
              _itemScrollController.jumpTo(
                index: initialIndex,
                alignment: 0,
              );
            }
          });

          return NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: surahPages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: QuranPageWidget(page: surahPages[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

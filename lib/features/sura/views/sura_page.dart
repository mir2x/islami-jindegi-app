import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/sura/models/sura_audio_state.dart';
import 'package:native_app/features/sura/views/widgets/audio_control_bar.dart';
import 'package:native_app/features/sura/views/widgets/ayah_card.dart';
import 'package:native_app/features/sura/views/widgets/ayah_placeholder.dart';
import 'package:native_app/features/sura/views/widgets/sura_app_bar.dart';
import 'package:native_app/features/sura/views/widgets/sura_bottom_nav_bar.dart';
import 'package:native_app/features/sura/utils/navigation_routes.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/sura_reciter_providers.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';
import '../../../shared/quran_data.dart';
import 'package:native_app/features/sura/views/widgets/drawer/side_drawer.dart';
import 'package:native_app/features/sura/views/widgets/tafsir_view.dart';
import 'package:native_app/features/sura_list/providers/sura_list_providers.dart';

class SurahPage extends ConsumerStatefulWidget {
  final int suraNumber;
  final int? initialScrollIndex;
  final String returnTo;
  const SurahPage({
    super.key,
    required this.suraNumber,
    this.initialScrollIndex,
    this.returnTo = suraListRoute,
  });

  @override
  ConsumerState<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends ConsumerState<SurahPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ScrollOffsetController _scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  bool _isAutoScrollAnimating = false;
  int _totalItems = 0;
  int _topVisibleIndex = 0;
  bool _showScrollToTopButton = false;
  int? _resolvedScrollIndex;
  int _bottomVisibleIndex = 0;
  bool _hasVisiblePositionUpdate = false;
  bool _nextSuraPromptShown = false;
  bool _isDraggingScrollThumb = false;
  double? _dragThumbProgress;

  late final StateController<Set<int>> _activePagesNotifier;

  void _log(String msg) {
    debugPrint('[SurahPage] $msg');
  }

  @override
  void initState() {
    super.initState();

    _itemPositionsListener.itemPositions
        .addListener(_onVisiblePositionsChanged);
    _activePagesNotifier = ref.read(activeSurahPagesProvider.notifier);

    // If initialScrollIndex is provided (e.g. from tafsir or search), use it directly.
    // Otherwise, load the last saved position from SharedPreferences.
    if (widget.initialScrollIndex != null) {
      _resolvedScrollIndex = widget.initialScrollIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _activePagesNotifier.update((state) => {...state, widget.suraNumber});
        _saveLastReadPosition(
          widget.suraNumber,
          widget.initialScrollIndex ?? 0,
        );
      });
    } else {
      _loadSavedScrollIndex();
    }
  }

  Future<void> _loadSavedScrollIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSura = prefs.getInt('last_read_sura');
    final savedIndex = prefs.getInt('last_read_ayah_index');

    if (mounted) {
      if (savedSura == widget.suraNumber &&
          savedIndex != null &&
          savedIndex > 0) {
        setState(() {
          _resolvedScrollIndex = savedIndex;
        });
        // Scroll to the saved position if the list is already attached
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_itemScrollController.isAttached) {
            _itemScrollController.jumpTo(
              index: savedIndex,
              alignment: 0.1,
            );
          }
        });
      }
      _activePagesNotifier.update((state) => {...state, widget.suraNumber});
      _saveLastReadPosition(widget.suraNumber, _resolvedScrollIndex ?? 0);
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions
        .removeListener(_onVisiblePositionsChanged);
    _activePagesNotifier.update((state) => state..remove(widget.suraNumber));
    _isAutoScrollAnimating = false;
    super.dispose();
  }

  void _onVisiblePositionsChanged() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final fullyEnteredTopItems = positions
        .where(
          (ItemPosition position) =>
              position.itemLeadingEdge >= 0 && position.itemLeadingEdge < 1,
        )
        .toList();

    final minIndex = (fullyEnteredTopItems.isNotEmpty
            ? fullyEnteredTopItems
            : positions
                .where((ItemPosition position) => position.itemTrailingEdge > 0)
                .toList())
        .reduce((min, position) => position.index < min.index ? position : min)
        .index;

    final maxIndex = positions
        .where((ItemPosition position) => position.itemLeadingEdge < 1)
        .reduce((max, position) => position.index > max.index ? position : max)
        .index;

    final shouldShow = minIndex > 5;
    final topChanged = minIndex != _topVisibleIndex;
    final bottomChanged = maxIndex != _bottomVisibleIndex;
    final buttonChanged = shouldShow != _showScrollToTopButton;

    if (topChanged) {
      _saveLastReadPosition(widget.suraNumber, minIndex);
    }

    if (topChanged || bottomChanged || buttonChanged) {
      if (!mounted) return;
      setState(() {
        _hasVisiblePositionUpdate = true;
        _topVisibleIndex = minIndex;
        _bottomVisibleIndex = maxIndex;
        _showScrollToTopButton = shouldShow;
      });
    }

    if (_bottomVisibleIndex < _totalItems - 1) {
      _nextSuraPromptShown = false;
    }
  }

  void _startAutoScroll() {
    if (_isAutoScrollAnimating || _totalItems == 0) return;

    ref.read(isAutoScrollingProvider.notifier).state = true;
    ref.read(isAutoScrollPausedProvider.notifier).state = false;
    _isAutoScrollAnimating = true;

    _smoothScrollLoop();
  }

  /// Continuously scrolls by small pixel increments for silky-smooth movement.
  /// Each iteration scrolls a fixed pixel chunk over a short duration.
  /// Speed factor controls how many pixels we move per tick.
  Future<void> _smoothScrollLoop() async {
    const tickDuration = Duration(milliseconds: 50);
    const basePixelsPerTick = 1.2; // pixels at 1.0x speed

    while (_isAutoScrollAnimating && mounted) {
      // Check pause state each tick
      if (ref.read(isAutoScrollPausedProvider)) {
        await Future.delayed(tickDuration);
        continue;
      }

      final speedFactor = ref.read(scrollSpeedFactorProvider);
      final pixelsToScroll = basePixelsPerTick * speedFactor;

      try {
        await _scrollOffsetController.animateScroll(
          offset: pixelsToScroll,
          duration: tickDuration,
          curve: Curves.linear,
        );
      } catch (_) {
        // Controller may not be attached yet or widget disposed
        break;
      }

      if (!mounted) break;
    }
  }

  void _stopAutoScroll({bool resetSpeed = false}) {
    _log('Stopping auto scroll. resetSpeed=$resetSpeed');
    if (!mounted) return;
    _isAutoScrollAnimating = false;

    ref.read(isAutoScrollingProvider.notifier).state = false;
    ref.read(isAutoScrollPausedProvider.notifier).state = false;
    if (resetSpeed) {
      ref.read(scrollSpeedFactorProvider.notifier).state = 1.0;
    }
  }

  void _togglePlayPauseAutoScroll() {
    final bool isPaused = ref.read(isAutoScrollPausedProvider);
    if (isPaused) {
      ref.read(isAutoScrollPausedProvider.notifier).state = false;
      // Loop will resume automatically via the pause check
    } else {
      ref.read(isAutoScrollPausedProvider.notifier).state = true;
    }
  }

  void _changeScrollSpeed(double delta) {
    final currentSpeed = ref.read(scrollSpeedFactorProvider);
    final newSpeed = (currentSpeed + delta).clamp(0.5, 3.0);
    ref.read(scrollSpeedFactorProvider.notifier).state = newSpeed;
    // Speed change takes effect immediately — the loop reads speed each tick
  }

  void _scrollToTop() {
    if (_itemScrollController.isAttached) {
      if (ref.read(isAutoScrollingProvider)) {
        _stopAutoScroll(resetSpeed: true);
      }
      _itemScrollController.scrollTo(
        index: 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveLastReadPosition(int sura, int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_read_sura', sura);
      await prefs.setInt('last_read_ayah_index', index);
    } catch (e) {
      _log('Error saving last read position: $e');
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isAtSuraEnd =>
      _totalItems > 0 && _bottomVisibleIndex >= _totalItems - 1;

  int get _currentAyahNumber {
    if (_hasVisiblePositionUpdate) {
      return _topVisibleIndex + 1;
    }
    return (_resolvedScrollIndex ?? 0) + 1;
  }

  Future<void> _showNextSuraPrompt() async {
    if (_nextSuraPromptShown || widget.suraNumber >= suraNames.length) return;

    _nextSuraPromptShown = true;
    final nextSuraNumber = widget.suraNumber + 1;
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
                    'সূরা শেষ হয়েছে',
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
                              buildSuraRoute(
                                suraNumber: nextSuraNumber,
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

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is OverscrollNotification &&
        notification.overscroll > 12 &&
        _isAtSuraEnd &&
        !_isDraggingScrollThumb) {
      _showNextSuraPrompt();
    }
    return false;
  }

  void _jumpToProgress(double progress) {
    if (_totalItems == 0 || !_itemScrollController.isAttached) return;
    final clamped = progress.clamp(0.0, 1.0);
    final targetIndex =
        ((clamped * (_totalItems - 1)).round()).clamp(0, _totalItems - 1);
    _itemScrollController.jumpTo(index: targetIndex, alignment: 0.08);
    _saveLastReadPosition(widget.suraNumber, targetIndex);
  }

  void _updateThumbFromTrackPosition(
    double localDy,
    double trackHeight,
    double thumbHeight,
  ) {
    final local = (localDy - (thumbHeight / 2)).clamp(
      0.0,
      trackHeight - thumbHeight,
    );
    final newProgress = (local / (trackHeight - thumbHeight)).clamp(0.0, 1.0);

    setState(() {
      _dragThumbProgress = newProgress;
    });

    _jumpToProgress(newProgress);
  }

  @override
  Widget build(BuildContext context) {
    final suraDataAsync = ref.watch(suraDataProvider(widget.suraNumber));
    final suraName = 'সূরা ${suraNames[widget.suraNumber - 1]}';
    final quranAudioState = ref.watch(suraAudioProvider);
    final isTimedScrolling = ref.watch(isAutoScrollingProvider);
    final showBottomNav = !isTimedScrolling && quranAudioState == null;

    ref.listen<ScrollCommand?>(suraScrollCommandProvider, (previous, next) {
      if (next != null &&
          next.suraNumber == widget.suraNumber &&
          _itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
          index: next.scrollIndex,
          alignment: 0.1,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
        ref.read(suraScrollCommandProvider.notifier).state = null;
      }
    });

    // Listen for tafsir command (from tilawat mode tap menu)
    ref.listen<OpenTafsirCommand?>(openTafsirCommandProvider, (previous, next) {
      if (next != null && next.suraNumber == widget.suraNumber) {
        // Clear the command
        ref.read(openTafsirCommandProvider.notifier).state = null;
        // Wait for scroll to complete, then open tafsir
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          final ayahs =
              ref.read(suraDataProvider(widget.suraNumber)).valueOrNull;
          if (ayahs != null && next.ayahNumber <= ayahs.length) {
            final ayah = ayahs[next.ayahNumber - 1];
            if (!context.mounted) return;
            showTafsirBottomSheet(
              context,
              suraNames[widget.suraNumber - 1],
              ayah,
            );
          }
        });
      }
    });

    ref.listen<AsyncValue<List<dynamic>>>(suraDataProvider(widget.suraNumber),
        (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        final scrollTarget = _resolvedScrollIndex;
        if (scrollTarget != null &&
            scrollTarget > 0 &&
            _itemScrollController.isAttached) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _itemScrollController.jumpTo(
              index: scrollTarget,
              alignment: 0.1,
            );
          });
        }
      }
    });

    ref.listen<SuraAudioState?>(suraAudioProvider, (previous, next) {
      if (next != null && next.isPlaying) {
        final ayahIndex = next.ayah - 1;
        if (ayahIndex >= 0 &&
            ayahIndex < _totalItems &&
            _itemScrollController.isAttached) {
          _itemScrollController.scrollTo(
            index: ayahIndex,
            alignment: 0.1,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Delay the provider update to avoid modifying during widget tree building
          Future(() {
            ref.read(lastViewedSuraProvider.notifier).state = widget.suraNumber;
          });
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: SuraAppBar(
          key: ValueKey(widget.suraNumber),
          title: suraName,
          suraNumber: widget.suraNumber,
          scaffoldKey: _scaffoldKey,
          currentAyahNumber: _currentAyahNumber,
          returnTo: widget.returnTo,
        ),
        drawer: SuraSideDrawer(
          currentSuraNumber: widget.suraNumber,
          currentAyahNumber: _currentAyahNumber,
          returnTo: widget.returnTo,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: suraDataAsync.when(
                  loading: () => ListView.builder(
                    itemCount: 15,
                    itemBuilder: (_, __) => const AyahPlaceholder(),
                  ),
                  error: (error, stack) => Center(
                    child: Text('Failed to load Sura details:\n$error'),
                  ),
                  data: (ayahs) {
                    _totalItems = ayahs.length;

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            NotificationListener<ScrollNotification>(
                              onNotification: _handleScrollNotification,
                              child: ScrollConfiguration(
                                behavior:
                                    const MaterialScrollBehavior().copyWith(
                                  scrollbars: false,
                                ),
                                child: ScrollablePositionedList.builder(
                                  itemScrollController: _itemScrollController,
                                  scrollOffsetController:
                                      _scrollOffsetController,
                                  itemPositionsListener: _itemPositionsListener,
                                  itemCount: _totalItems,
                                  initialScrollIndex: _resolvedScrollIndex ?? 0,
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    right: 44,
                                    bottom: 80,
                                  ),
                                  itemBuilder: (context, index) {
                                    final entry = ayahs[index];
                                    final isHighlighted =
                                        quranAudioState != null &&
                                            quranAudioState.surah ==
                                                widget.suraNumber &&
                                            quranAudioState.ayah == entry.ayah;

                                    return AyahCard(
                                      suraNumber: widget.suraNumber,
                                      ayah: entry,
                                      suraName: suraName,
                                      returnTo: widget.returnTo,
                                      isHighlighted: isHighlighted,
                                    );
                                  },
                                ),
                              ),
                            ),
                            _buildScrollThumb(context, constraints.maxHeight),
                            if (ref.watch(isAutoScrollingProvider))
                              _buildAutoScrollController(context),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              if (quranAudioState != null)
                AudioControllerBar(
                  color: Theme.of(context).extension<AppThemeColors>()!.cardBg,
                ),
            ],
          ),
        ),
        bottomNavigationBar: showBottomNav
            ? SuraBottomNavBar(
                totalAyahs: _totalItems,
                suraNumber: widget.suraNumber,
                currentAyahNumber: _currentAyahNumber,
                returnTo: widget.returnTo,
                onStartAutoScroll: _startAutoScroll,
                onStopAutoScroll: () => _stopAutoScroll(resetSpeed: true),
              )
            : null,
        floatingActionButton: _showScrollToTopButton && !isTimedScrolling
            ? Transform.translate(
                offset: const Offset(14, 0),
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  mini: true,
                  backgroundColor:
                      Theme.of(context).extension<AppThemeColors>()!.cardBg,
                  child: Icon(
                    Icons.arrow_upward,
                    color:
                        Theme.of(context).extension<AppThemeColors>()!.active,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildAutoScrollController(BuildContext context) {
    final scrollSpeedFactor = ref.watch(scrollSpeedFactorProvider);
    final isPaused = ref.watch(isAutoScrollPausedProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final accent = colors.active;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: colors.cardBg,
          border: Border(top: BorderSide(color: colors.divider)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                isPaused ? Icons.play_arrow : Icons.pause,
                color: accent,
              ),
              onPressed: _togglePlayPauseAutoScroll,
            ),
            IconButton(
              icon: Icon(Icons.remove, color: accent),
              onPressed: () => _changeScrollSpeed(-0.5),
            ),
            Text(
              '${scrollSpeedFactor.toStringAsFixed(1)}x',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: accent),
              onPressed: () => _changeScrollSpeed(0.5),
            ),
            IconButton(
              icon: Icon(Icons.close, color: accent),
              onPressed: () => _stopAutoScroll(resetSpeed: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollThumb(BuildContext context, double height) {
    if (_totalItems <= 1) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).extension<AppThemeColors>()!;
    const trackTop = 18.0;
    const trackBottom = 104.0;
    final trackHeight =
        (height - trackTop - trackBottom).clamp(120.0, double.infinity);
    const thumbHeight = 88.0;
    final progress = _dragThumbProgress ??
        (_topVisibleIndex / (_totalItems - 1)).clamp(0.0, 1.0);
    final top = trackTop + (trackHeight - thumbHeight) * progress;
    final visibleAyah = (_topVisibleIndex + 1).clamp(1, _totalItems);

    return Stack(
      children: [
        Positioned(
          right: 20,
          top: trackTop,
          child: Container(
            width: 6,
            height: trackHeight,
            decoration: BoxDecoration(
              color: colors.divider.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: trackTop,
          width: 56,
          height: trackHeight,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragStart: (details) {
              setState(() {
                _isDraggingScrollThumb = true;
                _dragThumbProgress = progress;
              });
              _updateThumbFromTrackPosition(
                details.localPosition.dy,
                trackHeight,
                thumbHeight,
              );
            },
            onVerticalDragUpdate: (details) {
              _updateThumbFromTrackPosition(
                details.localPosition.dy,
                trackHeight,
                thumbHeight,
              );
            },
            onVerticalDragEnd: (_) {
              setState(() {
                _isDraggingScrollThumb = false;
                _dragThumbProgress = null;
              });
            },
            onVerticalDragCancel: () {
              setState(() {
                _isDraggingScrollThumb = false;
                _dragThumbProgress = null;
              });
            },
            child: Stack(
              children: [
                Positioned(
                  right: 8,
                  top: top - trackTop,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: _isDraggingScrollThumb ? 42 : 36,
                    height: thumbHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.primary.withValues(alpha: 0.96),
                          colors.secondary.withValues(alpha: 0.84),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: 0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.drag_indicator_rounded,
                          color: colors.appBarText,
                          size: 18,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          visibleAyah.toBengaliDigit(),
                          style: TextStyle(
                            color: colors.appBarText,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'আয়াত',
                          style: TextStyle(
                            color: colors.appBarText,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

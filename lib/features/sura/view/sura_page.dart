import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:native_app/features/sura/model/sura_audio_state.dart';
import 'package:native_app/features/sura/view/widgets/audio_control_bar.dart';
import 'package:native_app/features/sura/view/widgets/ayah_card.dart';
import 'package:native_app/features/sura/view/widgets/ayah_placeholders.dart';
import 'package:native_app/features/sura/view/widgets/sura_app_bar.dart';
import 'package:native_app/features/sura/view/widgets/sura_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodel/sura_reciter_viewmodel.dart';
import 'package:native_app/features/sura/viewmodel/sura_viewmodel.dart';
import '../../../shared/quran_data.dart';

import 'package:native_app/features/sura/view/widgets/drawer/sura_selection_drawer.dart';
import 'package:native_app/features/sura/view/widgets/tafsir_view.dart';
import 'package:native_app/features/sura_list/viewmodel/sura_list_providers.dart';

class SurahPage extends ConsumerStatefulWidget {
  final int suraNumber;
  final int? initialScrollIndex;
  const SurahPage(
      {super.key, required this.suraNumber, this.initialScrollIndex});

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

  late final StateController<Set<int>> _activePagesNotifier;

  void _log(String msg) {
    print('[SurahPage] $msg');
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
            widget.suraNumber, widget.initialScrollIndex ?? 0);
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

    final minIndex = positions
        .where((ItemPosition position) => position.itemTrailingEdge > 0)
        .reduce((min, position) => position.index < min.index ? position : min)
        .index;

    if (minIndex != _topVisibleIndex) {
      _topVisibleIndex = minIndex;
      _saveLastReadPosition(widget.suraNumber, minIndex);
      final shouldShow = minIndex > 5;
      if (shouldShow != _showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = shouldShow;
        });
      }
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

  @override
  Widget build(BuildContext context) {
    final suraDataAsync = ref.watch(suraDataProvider(widget.suraNumber));
    final suraName = "সূরা ${suraNames[widget.suraNumber - 1]}";
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
            showTafsirBottomSheet(
                context, suraNames[widget.suraNumber - 1], ayah);
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
        ),
        drawer: SuraSelectionDrawer(currentSuraNumber: widget.suraNumber),
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
                      child: Text('Failed to load Sura details:\n$error')),
                  data: (ayahs) {
                    _totalItems = ayahs.length;

                    return Stack(
                      children: [
                        ScrollablePositionedList.builder(
                          itemScrollController: _itemScrollController,
                          scrollOffsetController: _scrollOffsetController,
                          itemPositionsListener: _itemPositionsListener,
                          itemCount: _totalItems,
                          initialScrollIndex: _resolvedScrollIndex ?? 0,
                          padding: const EdgeInsets.only(bottom: 80.0),
                          itemBuilder: (context, index) {
                            final entry = ayahs[index];
                            final isHighlighted = quranAudioState != null &&
                                quranAudioState.surah == widget.suraNumber &&
                                quranAudioState.ayah == entry.ayah;

                            return AyahCard(
                              suraNumber: widget.suraNumber,
                              ayah: entry,
                              suraName: suraName,
                              isHighlighted: isHighlighted,
                            );
                          },
                        ),
                        if (ref.watch(isAutoScrollingProvider))
                          _buildAutoScrollController(context),
                      ],
                    );
                  },
                ),
              ),
              if (quranAudioState != null)
                AudioControllerBar(color: Theme.of(context).primaryColor),
            ],
          ),
        ),
        bottomNavigationBar: showBottomNav
            ? SuraBottomNavBar(
                totalAyahs: _totalItems,
                suraNumber: widget.suraNumber,
                onStartAutoScroll: _startAutoScroll,
                onStopAutoScroll: () => _stopAutoScroll(resetSpeed: true),
              )
            : null,
        floatingActionButton: _showScrollToTopButton
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                mini: true,
                backgroundColor: Colors.green,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildAutoScrollController(BuildContext context) {
    final scrollSpeedFactor = ref.watch(scrollSpeedFactorProvider);
    final isPaused = ref.watch(isAutoScrollPausedProvider);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.green.shade900),
              onPressed: _togglePlayPauseAutoScroll,
            ),
            IconButton(
                icon: Icon(Icons.remove, color: Colors.green.shade900),
                onPressed: () => _changeScrollSpeed(-0.5)),
            Text('${scrollSpeedFactor.toStringAsFixed(1)}x',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900)),
            IconButton(
                icon: Icon(Icons.add, color: Colors.green.shade900),
                onPressed: () => _changeScrollSpeed(0.5)),
            IconButton(
                icon: Icon(Icons.close, color: Colors.green.shade900),
                onPressed: () => _stopAutoScroll(resetSpeed: true)),
          ],
        ),
      ),
    );
  }
}

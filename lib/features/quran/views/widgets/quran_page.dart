import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:native_app/features/quran/views/widgets/page_info_overlay.dart';
import '../../../../core/constants.dart';
import '../../../../theme/app_theme_color.dart';
import '../../models/ayah_box.dart';
import '../../models/selected_ayah_state.dart';
import '../../providers/ayah_highlight_providers.dart';
import 'ayah_highlighter.dart';
import 'ayah_menu.dart';

class QuranPage extends ConsumerStatefulWidget {
  final int pageIndex;
  final Directory editionDir;
  final int imageWidth;
  final int imageHeight;
  final String imageExt;
  const QuranPage({
    super.key,
    required this.pageIndex,
    required this.editionDir,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageExt,
  });

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage> {
  late final TransformationController _controller;

  @override
  void initState() {
    super.initState();
    final scale = ref.read(quranPageScaleProvider);
    _controller = TransformationController(
      Matrix4.diagonal3Values(scale, scale, 1.0),
    );
    _controller.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTransformChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final scale = _getScale();
    // Update zoom state for PageView physics
    final isZoomed = scale > 1.05;
    if (ref.read(quranPageZoomedProvider) != isZoomed) {
      ref.read(quranPageZoomedProvider.notifier).state = isZoomed;
    }
  }

  double _getScale() {
    final m = _controller.value;
    return m.getMaxScaleOnAxis();
  }

  /// Apply the current transform to a rect (layout coords → visual coords).
  Rect _transformRect(Rect rect) {
    final m = _controller.value;
    final tl = MatrixUtils.transformPoint(m, rect.topLeft);
    final br = MatrixUtils.transformPoint(m, rect.bottomRight);
    return Rect.fromPoints(tl, br);
  }

  @override
  Widget build(BuildContext context) {
    // Keep controller in sync when +/- buttons change the scale provider
    final targetScale = ref.watch(quranPageScaleProvider);
    final currentScale = _getScale();
    if ((currentScale - targetScale).abs() > 0.01) {
      // Rebuild the matrix centred on viewport origin, preserving no pan
      // (buttons always reset pan so you see the full page at new scale)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _controller.value = Matrix4.diagonal3Values(
          targetScale,
          targetScale,
          1.0,
        );
      });
    }

    final allBoxesAsync = ref.watch(allBoxesProvider);
    final selectedState = ref.watch(selectedAyahProvider);
    final touchModeOn = ref.watch(touchModeProvider);

    final logicalPage = widget.pageIndex + 1;
    final pageNumber = logicalPage < kFirstPageNumber ? -1 : logicalPage;
    final boxes = pageNumber == -1
        ? const <AyahBox>[]
        : ref.watch(boxesForPageProvider(pageNumber));
    final notifier = ref.read(selectedAyahProvider.notifier);
    final imgFile = File(
      '${widget.editionDir.path}/qm${widget.pageIndex + 1}.${widget.imageExt}',
    );

    final bool isSelectedAyahOnThisPage = selectedState != null &&
        pageNumber != -1 &&
        boxes.any(
          (box) =>
              box.suraNumber == selectedState.suraNumber &&
              box.ayahNumber == selectedState.ayahNumber,
        );

    final bool showMenuOnThisPage = selectedState != null &&
        selectedState.source == AyahSelectionSource.tap &&
        isSelectedAyahOnThisPage;

    return allBoxesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(e.toString(), style: TextStyle(fontSize: 14.sp)),
      ),
      data: (_) => LayoutBuilder(
        builder: (_, constraints) {
          final scaleX = constraints.maxWidth / widget.imageWidth;
          final scaleY = constraints.maxHeight / widget.imageHeight;

          List<Rect> highlightRects = [];
          Rect? menuAnchorRect;

          if (selectedState != null && isSelectedAyahOnThisPage) {
            final boxesForAyah = boxes
                .where(
                  (box) =>
                      box.suraNumber == selectedState.suraNumber &&
                      box.ayahNumber == selectedState.ayahNumber,
                )
                .toList();

            if (boxesForAyah.isNotEmpty) {
              highlightRects = boxesForAyah.map((box) {
                return Rect.fromLTWH(
                  box.minX * scaleX,
                  box.minY * scaleY,
                  box.width * scaleX,
                  box.height * scaleY,
                );
              }).toList();

              try {
                final firstBox =
                    boxesForAyah.reduce((a, b) => a.boxId < b.boxId ? a : b);
                menuAnchorRect = Rect.fromLTWH(
                  firstBox.minX * scaleX,
                  firstBox.minY * scaleY,
                  firstBox.width * scaleX,
                  firstBox.height * scaleY,
                );
              } catch (e) {
                debugPrint('Error finding anchor box: $e');
              }
            }
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Zoomable content ──────────────────────────────────────
              InteractiveViewer(
                transformationController: _controller,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 1.0,
                maxScale: 3.0,
                panEnabled: _getScale() > 1.05,
                onInteractionEnd: (_) {
                  // Sync scale back to provider after pinch
                  ref
                      .read(quranPageScaleProvider.notifier)
                      .setScale(_getScale());
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: Colors.white,
                      child: Image.file(imgFile, fit: BoxFit.fill),
                    ),
                    CustomPaint(
                      painter: AyahHighlighter(
                        highlightRects,
                        Theme.of(context)
                            .extension<AppThemeColors>()!
                            .selectionOverlay
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    // Tap detector lives INSIDE the viewer so Flutter's hit
                    // testing handles the transform and localPosition is
                    // already in the image's coordinate space.
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: touchModeOn
                          ? (_) => ref
                              .read(barsVisibilityProvider.notifier)
                              .toggle()
                          : (details) {
                              final logicX =
                                  details.localPosition.dx / scaleX;
                              final logicY =
                                  details.localPosition.dy / scaleY;
                              final tapped = boxes
                                  .where((b) => b.contains(logicX, logicY))
                                  .toList();

                              if (tapped.isNotEmpty) {
                                final s = tapped.first.suraNumber;
                                final a = tapped.first.ayahNumber;
                                if (selectedState != null &&
                                    selectedState.source ==
                                        AyahSelectionSource.tap &&
                                    selectedState.suraNumber == s &&
                                    selectedState.ayahNumber == a) {
                                  notifier.clear();
                                } else {
                                  notifier.selectByTap(s, a);
                                }
                              } else {
                                notifier.clear();
                              }
                            },
                      child: Container(),
                    ),
                  ],
                ),
              ),

              // ── Ayah menu – positioned in visual (transformed) coords ─
              if (showMenuOnThisPage && menuAnchorRect != null)
                AyahMenu(anchorRect: _transformRect(menuAnchorRect)),

              // ── Page info overlay stays at fixed position ─────────────
              PageInfoOverlay(pageIndex: widget.pageIndex),
            ],
          );
        },
      ),
    );
  }
}

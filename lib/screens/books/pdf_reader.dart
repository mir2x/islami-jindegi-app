import 'dart:io' show Platform;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/local_file.dart';

class PDFReader extends ConsumerStatefulWidget {
  const PDFReader({
    super.key,
    required this.bookId,
    required this.filePath,
    required this.preferences,
    required this.isFullScreen,
    required this.darkMode,
    required this.landscape,
    required this.toggleFullScreen,
  });

  final String bookId;
  final String filePath;
  final dynamic preferences;
  final bool isFullScreen;
  final bool darkMode;
  final bool landscape;
  final void Function() toggleFullScreen;

  @override
  ConsumerState<PDFReader> createState() => _PDFReaderState();
}

class _PDFReaderState extends ConsumerState<PDFReader> {
  final pdfController = PdfViewerController();
  int? stickyPageNumber;

  @override
  Widget build(BuildContext context) {
    // Parent (BookItem) already verified the file is downloaded before rendering PDFReader
    // So we can directly watch localFileProvider
    var pdfFile = ref.watch(localFileProvider(widget.filePath));
    debugPrint('[PDFReader] build called for: ${widget.filePath}');

    return pdfFile.when(
      loading: () {
        debugPrint('[PDFReader] pdfFile loading for: ${widget.filePath}');
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      data: (localFile) {
        debugPrint(
            '[PDFReader] pdfFile data: localFile=${localFile?.path} for: ${widget.filePath}');

        if (localFile == null) {
          return const Center(
            child: Text('File not found'),
          );
        }

        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;
        int platformAjdustment = Platform.isAndroid ? -4 : 30;
        double barHeight = kToolbarHeight +
            MediaQueryData.fromView(
              ui.PlatformDispatcher.instance.implicitView!,
            ).padding.top +
            kBottomNavigationBarHeight +
            platformAjdustment;
        double heightAdjustment = widget.isFullScreen ? 0 : barHeight;

        int initalPage =
            widget.preferences.getInt('pdfResource-${widget.bookId}') ?? 1;

        return SizedBox(
          height: screenHeight - heightAdjustment,
          child: GestureDetector(
            onTap: () {
              stickyPageNumber = pdfController.pageNumber;
              widget.toggleFullScreen();
            },
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white,
                widget.darkMode ? BlendMode.difference : BlendMode.dst,
              ),
              child: RotatedBox(
                quarterTurns: widget.landscape ? 3 : 0,
                child: PdfViewer.file(
                  localFile.path,
                  controller: pdfController,
                  initialPageNumber: initalPage,
                  params: PdfViewerParams(
                    margin: 0,
                    layoutPages: (pages, params) {
                      final pageCount = pages.length;
                      var pageLayouts = <Rect>[];
                      double viewWidth;
                      double viewHeight;
                      double width;
                      double height;

                      if (widget.landscape) {
                        viewWidth = screenHeight - heightAdjustment;
                        viewHeight = (screenHeight - heightAdjustment) * 1.5;

                        width = viewWidth;
                        height = pageCount * viewHeight;
                        double y = 0;
                        double heightLimit = height - 10;

                        while (y < heightLimit) {
                          pageLayouts.add(
                            Rect.fromLTWH(
                              0,
                              y,
                              viewWidth,
                              viewHeight,
                            ),
                          );
                          y += viewHeight;
                        }
                      } else {
                        viewWidth = screenWidth;
                        viewHeight = screenHeight - heightAdjustment;

                        width = pageCount * viewWidth;
                        height = viewHeight;
                        double x = 0;
                        double widthLimit = width - 10;

                        while (x < widthLimit) {
                          pageLayouts.add(
                            Rect.fromLTWH(
                              x,
                              0,
                              viewWidth,
                              viewHeight,
                            ),
                          );
                          x += viewWidth;
                        }
                      }

                      return PdfPageLayout(
                        pageLayouts: pageLayouts,
                        documentSize: Size(width, height),
                      );
                    },
                    onPageChanged: (page) {
                      if (page == null) {
                        return;
                      }

                      EasyDebounce.debounce(
                          'book-page', const Duration(milliseconds: 500),
                          () async {
                        await widget.preferences.setInt(
                          'pdfResource-${widget.bookId}',
                          page,
                        );

                        if (!widget.landscape) {
                          pdfController.goToPage(pageNumber: page);
                        }
                      });
                    },
                    onInteractionUpdate: (gesture) {
                      if (widget.landscape) {
                        return;
                      }

                      EasyDebounce.debounce(
                          'page-interaction', const Duration(milliseconds: 200),
                          () {
                        if (pdfController.pageNumber != null &&
                            gesture.scale == 1) {
                          int page = pdfController.pageNumber!;

                          double calcIntersectionArea() {
                            final rect =
                                pdfController.layout.pageLayouts[page - 1];
                            final intersection =
                                rect.intersect(pdfController.visibleRect);

                            if (intersection.isEmpty) return 0;

                            return intersection.width / rect.width;
                          }

                          final ratio = calcIntersectionArea();
                          final delta = gesture.focalPointDelta;

                          if (ratio < 0.98) {
                            double scale = pdfController.currentZoom;

                            if (scale < 1.01 && scale > 0.99) {
                              if (delta.dx > 0) {
                                pdfController.goToPage(
                                  pageNumber: page - 1,
                                );
                              } else if (delta.dx < 0) {
                                pdfController.goToPage(
                                  pageNumber: page + 1,
                                );
                              } else {
                                pdfController.goToPage(pageNumber: page);
                              }
                            }
                          } else {
                            pdfController.goToPage(pageNumber: page);
                          }
                        }
                      });
                    },
                    onViewSizeChanged: (_, __, controller) {
                      int? pageNumber =
                          stickyPageNumber ?? controller.pageNumber;

                      if (pageNumber != null) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () {
                            controller.goToPage(pageNumber: pageNumber);
                          },
                        );
                      }
                    },
                    viewerOverlayBuilder: (context, size, handleLinkTap) => [
                      PdfViewerScrollThumb(
                        controller: pdfController,
                        orientation: widget.landscape
                            ? ScrollbarOrientation.right
                            : ScrollbarOrientation.top,
                        thumbSize: const Size(100, 25),
                        thumbBuilder:
                            (context, thumbSize, pageNumber, controller) {
                          String currentLang =
                              Localizations.localeOf(context).languageCode;
                          var numFormatter = NumberFormat('#', currentLang);
                          var textTheme = Theme.of(context).textTheme;

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(0, 1.5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${numFormatter.format(pageNumber)} / ${numFormatter.format(controller.pageCount)}',
                                style: textTheme.labelMedium,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    loadingBannerBuilder: (_, __, ___) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBannerBuilder: (context, _, __, ___) {
                      var locales = AppLocalizations.of(context)!;
                      var textTheme = Theme.of(context).textTheme;

                      return AlertDialog(
                        title: Text(locales.errorTitle),
                        content: Text(
                          locales.documentLoadErrorMsg,
                          style: textTheme.labelMedium,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

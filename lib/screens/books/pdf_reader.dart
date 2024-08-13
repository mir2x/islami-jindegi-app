import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/providers/check_downloaded_file.dart';

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

  @override
  Widget build(BuildContext context) {
    var checkFileProvider = checkDownloadedFileProvider(widget.filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);

    return checkDownloadedFile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (isDownloaded) {
        if (isDownloaded) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          double barHeight = kToolbarHeight +
              MediaQueryData.fromView(
                ui.PlatformDispatcher.instance.implicitView!,
              ).padding.top +
              kBottomNavigationBarHeight;
          double heightAdjustment = widget.isFullScreen ? 0 : barHeight;

          var pdfFile = ref.watch(localFileProvider(widget.filePath));

          return SizedBox(
            height: screenHeight - heightAdjustment,
            child: GestureDetector(
              onTap: () => widget.toggleFullScreen(),
              child: pdfFile.when(
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                data: (localFile) {
                  int initalPage = widget.preferences
                          .getInt('pdfResource-${widget.bookId}') ??
                      1;

                  return ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      widget.darkMode ? BlendMode.difference : BlendMode.dst,
                    ),
                    child: RotatedBox(
                      quarterTurns: widget.landscape ? 3 : 0,
                      child: PdfViewer.file(
                        localFile!.path,
                        controller: pdfController,
                        initialPageNumber: initalPage,
                        params: PdfViewerParams(
                          margin: 0,
                          layoutPages: (pages, params) {
                            final pageCount = pages.length;
                            double height;
                            double viewWidth;

                            if (widget.landscape) {
                              height = (screenHeight - heightAdjustment) * 1.5;
                              viewWidth = screenHeight - heightAdjustment;
                            } else {
                              height = screenHeight - heightAdjustment;
                              viewWidth = screenWidth;
                            }

                            final width = pageCount * viewWidth;
                            final pageLayouts = <Rect>[];
                            double x = 0;

                            while (x < (width - 10)) {
                              pageLayouts.add(
                                Rect.fromLTWH(
                                  x,
                                  0,
                                  viewWidth,
                                  height,
                                ),
                              );
                              x += viewWidth;
                            }

                            return PdfPageLayout(
                              pageLayouts: pageLayouts,
                              documentSize: Size(width, height),
                            );
                          },
                          onPageChanged: (page) async {
                            await widget.preferences.setInt(
                              'pdfResource-${widget.bookId}',
                              page,
                            );
                          },
                          viewerOverlayBuilder:
                              (context, size, handleLinkTap) => [
                            PdfViewerScrollThumb(
                              controller: pdfController,
                              orientation: ScrollbarOrientation.top,
                              thumbSize: const Size(100, 25),
                              thumbBuilder:
                                  (context, thumbSize, pageNumber, controller) {
                                String currentLang =
                                    Localizations.localeOf(context)
                                        .languageCode;
                                var numFormatter =
                                    NumberFormat('#', currentLang);
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
                  );
                },
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

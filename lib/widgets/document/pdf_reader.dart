import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdfx/pdfx.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/pdf_controller.dart';
import 'pdf_builders.dart';

class PDFReader extends ConsumerWidget {
  const PDFReader({
    super.key,
    required this.document,
  });

  final Map document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String filePath = document['id'];

    var checkFileProvider = checkDownloadedFileProvider(filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);

    return checkDownloadedFile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (isDownloaded) {
        if (isDownloaded) {
          var pdfCtrl = ref.watch(pdfControllerProvider(document));

          return Container(
            height: 540,
            margin: const EdgeInsets.only(bottom: 10),
            child: pdfCtrl.when(
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              data: (pdfController) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.navigate_before),
                          iconSize: 45,
                          onPressed: () {
                            pdfController.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                        PdfPageNumber(
                          controller: pdfController,
                          // When `loadingState != PdfLoadingState.success`  `pagesCount` equals null_
                          builder: (_, state, loadingState, pagesCount) {
                            var page = pdfController.pageListenable.value;

                            return Text(
                              '$page/${pagesCount ?? 0}',
                              style: textTheme.labelMedium,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.navigate_next),
                          iconSize: 45,
                          onPressed: () {
                            pdfController.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: PdfView(
                        controller: pdfController,
                        builders:
                            PdfBuilders(locales: locales, textTheme: textTheme)
                                .getViewBuilders(),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

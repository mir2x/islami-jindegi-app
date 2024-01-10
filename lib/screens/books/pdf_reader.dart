import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/providers/pdf_controller.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/objects/pdf_source.dart';
import 'package:native_app/objects/pdf_builders.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';

class PDFReader extends ConsumerWidget {
  const PDFReader({
    super.key,
    required this.bookId,
    required this.bookTitle,
    required this.image,
    required this.document,
  });

  final String bookId;
  final String bookTitle;
  final Widget image;
  final Map document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    String filePath = fileTitlePath(bookTitle, document['id']);

    var checkFileProvider = checkDownloadedFileProvider(filePath);
    var checkDownloadedFile = ref.watch(checkFileProvider);

    return checkDownloadedFile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (isDownloaded) {
        if (isDownloaded) {
          PdfSource params = PdfSource(
            resourceId: bookId,
            filePath: filePath,
          );

          var pdfCtrl = ref.watch(pdfControllerProvider(params));

          return Container(
            height: 540,
            margin: const EdgeInsets.only(bottom: 30),
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
                        onPageChanged: (page) async {
                          var prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('pdfResource-$bookId', page);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          double screenWidth = MediaQuery.of(context).size.width;

          return Column(
            children: [
              WithConnectivity(
                builder: (context, isConnected) {
                  if (!isConnected) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const ConnectToInternet(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 30),
                  width: screenWidth / 2,
                  child: image,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

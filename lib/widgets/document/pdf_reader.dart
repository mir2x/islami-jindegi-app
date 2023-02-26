import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:pdfx/pdfx.dart';
import 'package:internet_file/internet_file.dart';
import 'package:native_app/providers/local_file.dart';

class PDFReader extends ConsumerWidget {
  const PDFReader({
    super.key,
    required this.document,
  });

  final Map document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var documentPath = document['id'];
    var localFile = ref.watch(localFileProvider(documentPath));

    return localFile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (localDocument) {
        dynamic pdfController;

        if (localDocument != null) {
          pdfController = PdfController(
            document: PdfDocument.openFile(localDocument.path),
          );
        } else {
          pdfController = PdfController(
            document: PdfDocument.openData(
              InternetFile.get(fileSrcUrl(document)),
            ),
          );
        }

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
              ),
            ),
          ],
        );
      },
    );
  }
}

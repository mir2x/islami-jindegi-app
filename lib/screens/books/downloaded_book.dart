import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/downloaded_books.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'pdf_reader.dart';

class DownloadedBook extends ConsumerWidget {
  const DownloadedBook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int id = int.parse(QR.params['id'].toString());
    var modelQuery = ref.watch(getDownloadedBookProvider(id));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        Map document = json.decode(book.document);
        String filePath = fileTitlePath(book.title, document['id']);

        return WithPreferences(
          builder: (context, preferences) {
            return Scaffold(
              body: PDFReader(
                bookId: book.bookId,
                filePath: filePath,
                preferences: preferences,
                title: book.title,
                authors: book.authors,
                fileLink: fileSrcUrl(document),
              ),
            );
          },
        );
      },
    );
  }
}

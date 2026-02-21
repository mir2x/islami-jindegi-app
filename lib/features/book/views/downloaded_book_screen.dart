import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/screens/books/pdf_reader.dart';
import '../providers/book_download_providers.dart';

class DownloadedBookScreen extends ConsumerWidget {
  const DownloadedBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String bookId = QR.params['id'].toString();
    var modelQuery = ref.watch(downloadedBookByBookIdProvider(bookId));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        if (book == null) {
          return const ModelExeptionHandler(error: 'Downloaded book not found');
        }

        Map document = json.decode(book.document ?? '{}');
        String filePath = fileTitlePath(book.title ?? '', document['id']);

        return WithPreferences(
          builder: (context, preferences) {
            return Scaffold(
              body: PDFReader(
                bookId: book.bookId,
                filePath: filePath,
                preferences: preferences,
                title: book.title ?? '',
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

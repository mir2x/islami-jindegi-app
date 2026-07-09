import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/features/book/views/pdf_reader.dart';
import '../providers/book_download_providers.dart';

class DownloadedBookScreen extends ConsumerWidget {
  const DownloadedBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String bookId = GoRouterState.of(context).pathParameters['id'].toString();
    var modelQuery = ref.watch(downloadedBookByBookIdProvider(bookId));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        if (book == null) {
          return const ModelExeptionHandler(error: 'Downloaded book not found');
        }

        String filePath =
            fileTitlePath(book.title ?? '', 'books/${book.bookId}');

        return WithPreferences(
          builder: (context, preferences) {
            return Scaffold(
              body: PDFReader(
                bookId: book.bookId ?? '',
                filePath: filePath,
                preferences: preferences,
                title: book.title ?? '',
                authors: book.authors,
                fileLink: book.document,
              ),
            );
          },
        );
      },
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/downloaded_books.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'display.dart';
import 'image.dart';

class DownloadedBook extends ConsumerWidget {
  const DownloadedBook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    int id = int.parse(QR.params['id'].toString());
    var modelQuery = ref.watch(getDownloadedBookProvider(id));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (book) {
        Map document = json.decode(book.document);

        return AppScaffold(
          showPattern: false,
          title: Text(locales.book),
          body: ItemContent(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(book.authors),
                    ),
                  ],
                ),
              ),
              BookDisplay(
                id: book.bookId,
                title: book.title,
                excerpt: book.excerpt,
                publisher: book.publisher,
                price: book.price,
                image: BookImage(
                  bookId: book.bookId,
                  image: json.decode(book.image),
                ),
                document: document,
                publishedAt: book.publishedAt,
                downloadItem: (document.isNotEmpty)
                    ? DownloadItem(
                        filePath: fileTitlePath(book.title, document['id']),
                        fileUrl: fileSrcUrl(document),
                        deleteCallback: () async {
                          await ref
                              .watch(downloadedBooksProvider.notifier)
                              .deleteItem(book.bookId);

                          await QR.to('books/downloads');
                        },
                      )
                    : null,
              ),
            ],
          ),
          bottomBar: BottomBar(
            alignment: MainAxisAlignment.center,
            children: [
              SocialShare(
                title: book.title,
                subtitle: book.authors,
                link: 'books/${book.bookId}',
                fileLink: fileSrcUrl(document),
              ),
              BookmarkButton(
                type: 'Book',
                title: book.title,
                link: 'books/${book.bookId}',
              ),
            ],
          ),
        );
      },
    );
  }
}

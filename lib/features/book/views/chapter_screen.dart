import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/book_providers.dart';

class ChapterScreen extends ConsumerWidget {
  const ChapterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var chapterId = QR.params['chapter_id'].toString();
    var bookId = QR.params['id'].toString();

    var modelQuery = ref.watch(chapterDetailProvider(chapterId));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        if (resource == null) {
          return const ModelExeptionHandler(error: 'Chapter not found');
        }

        Future? previousPage() async {
          final offline = ref.read(bookOfflineServiceProvider);
          var previousResources = await offline.queryChapters(
            bookId: bookId,
            position: (resource.position ?? 0) - 1,
            quantity: 1,
            includeSubchapters: true,
          );

          if (previousResources.isEmpty) {
            await QR.to('books-v2/$bookId');
          } else {
            var subchapters = previousResources.first.subchapters;

            if (subchapters.isNotEmpty) {
              var lastSubchapter = subchapters.last;
              await QR.to(
                'books-v2/$bookId/subchapters/${lastSubchapter.id}',
              );
            } else {
              await QR.to(
                'books-v2/$bookId/chapters/${previousResources.first.id}',
              );
            }
          }
        }

        Future? nextPage() async {
          final offline = ref.read(bookOfflineServiceProvider);
          var nextResources = await offline.queryChapters(
            bookId: bookId,
            position: (resource.position ?? 0) + 1,
            quantity: 1,
            includeSubchapters: true,
          );

          if (nextResources.isNotEmpty) {
            var subchapters = nextResources.first.subchapters;

            if (subchapters.isNotEmpty) {
              await QR.to(
                'books-v2/$bookId/subchapters/${subchapters.first.id}',
              );
            } else {
              await QR.to(
                'books-v2/$bookId/chapters/${nextResources.first.id}',
              );
            }
          }
        }

        // Track last visited chapter (deferred to avoid modifying state during build)
        Future(() {
          ref.read(bookLastChapterProvider.notifier).updateLastChapter(
                bookId,
                resource.id,
              );
        });

        return ResizableFont(
          storeKey: 'bookFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await QR.to('books-v2/$bookId'),
              showPattern: false,
              title: Text(locales.book),
              body: NextPageSwipe(
                onPrevious: previousPage,
                onNext: nextPage,
                child: ItemContent(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: PageTitle(
                        text: resource.title,
                        fontSizeRatio: fontSizeRatio,
                      ),
                    ),
                    if (resource.body != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: PageHtmlBody(
                          text: resource.body ?? '',
                          fontSizeRatio: fontSizeRatio,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              bottomBar: BottomBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Previous(onPrevious: previousPage),
                  Row(
                    children: [
                      SocialShare(
                        title: resource.title,
                        body: resource.body,
                        link: 'books/$bookId/chapters/${resource.id}',
                      ),
                      BookmarkButton(
                        type: 'Book Chapter',
                        title: resource.title,
                        link: 'books/$bookId/chapters/${resource.id}',
                      ),
                    ],
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'bookFontRatio',
                  ),
                  Next(onNext: nextPage),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

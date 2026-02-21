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

class SubchapterScreen extends ConsumerWidget {
  const SubchapterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var subchapterId = QR.params['subchapter_id'].toString();
    var bookId = QR.params['id'].toString();

    var modelQuery = ref.watch(subchapterDetailProvider(subchapterId));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        if (resource == null) {
          return const ModelExeptionHandler(error: 'Subchapter not found');
        }

        var chapterId = resource.chapter?.id ?? resource.chapterId ?? '';

        Future? previousPage() async {
          final offline = ref.read(bookOfflineServiceProvider);

          var previousResources = await offline.querySubchapters(
            chapterId: chapterId,
            position: (resource.position ?? 0) - 1,
            quantity: 1,
          );

          if (previousResources.isNotEmpty) {
            await QR.to(
              'books-v2/$bookId/subchapters/${previousResources.first.id}',
            );
          } else {
            // Go to the previous chapter
            var currentChapter = await offline.findChapterById(chapterId);

            if (currentChapter != null) {
              var previousChapters = await offline.queryChapters(
                bookId: bookId,
                position: (currentChapter.position ?? 0) - 1,
                quantity: 1,
                includeSubchapters: true,
              );

              if (previousChapters.isEmpty) {
                await QR.to('books-v2/$bookId');
              } else {
                var subchapters = previousChapters.first.subchapters;

                if (subchapters.isNotEmpty) {
                  var lastSubchapter = subchapters.last;
                  await QR.to(
                    'books-v2/$bookId/subchapters/${lastSubchapter.id}',
                  );
                } else {
                  await QR.to(
                    'books-v2/$bookId/chapters/${previousChapters.first.id}',
                  );
                }
              }
            }
          }
        }

        Future? nextPage() async {
          final offline = ref.read(bookOfflineServiceProvider);

          var nextResources = await offline.querySubchapters(
            chapterId: chapterId,
            position: (resource.position ?? 0) + 1,
            quantity: 1,
          );

          if (nextResources.isNotEmpty) {
            await QR.to(
              'books-v2/$bookId/subchapters/${nextResources.first.id}',
            );
          } else {
            // Go to the next chapter
            var currentChapter = await offline.findChapterById(chapterId);

            if (currentChapter != null) {
              var nextChapters = await offline.queryChapters(
                bookId: bookId,
                position: (currentChapter.position ?? 0) + 1,
                quantity: 1,
                includeSubchapters: true,
              );

              if (nextChapters.isNotEmpty) {
                var subchapters = nextChapters.first.subchapters;

                if (subchapters.isNotEmpty) {
                  await QR.to(
                    'books-v2/$bookId/subchapters/${subchapters.first.id}',
                  );
                } else {
                  await QR.to(
                    'books-v2/$bookId/chapters/${nextChapters.first.id}',
                  );
                }
              }
            }
          }
        }

        // Track last visited (deferred to avoid modifying state during build)
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
                        link: 'books/$bookId/subchapters/${resource.id}',
                      ),
                      BookmarkButton(
                        type: 'Book Subchapter',
                        title: resource.title,
                        link: 'books/$bookId/subchapters/${resource.id}',
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

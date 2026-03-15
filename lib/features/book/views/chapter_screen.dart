import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
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
import '../models/book_subchapter.dart';
import '../providers/book_providers.dart';

class ChapterScreen extends ConsumerWidget {
  const ChapterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var chapterId =
        GoRouterState.of(context).pathParameters['chapter_id'].toString();
    var bookId = GoRouterState.of(context).pathParameters['id'].toString();

    var modelQuery = ref.watch(chapterDetailProvider(chapterId));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        if (resource == null) {
          return const ModelExeptionHandler(error: 'Chapter not found');
        }

        Future<List<dynamic>> orderedEntries() async {
          final chapters = await ref.read(
            chapterListProvider(
              ChapterListParams(
                bookId: bookId,
                includeSubchapters: true,
              ),
            ).future,
          );

          final entries = <dynamic>[];
          for (final chapter in chapters) {
            if (chapter.subchapters.isEmpty) {
              entries.add(chapter);
            } else {
              entries.addAll(chapter.subchapters);
            }
          }
          return entries;
        }

        Future? previousPage() async {
          final entries = await orderedEntries();
          final currentIndex = entries.indexWhere(
            (entry) => entry.id == resource.id,
          );

          if (currentIndex <= 0) {
            context.go('/books/$bookId');
            return;
          }

          final previousEntry = entries[currentIndex - 1];
          if (previousEntry is BookSubchapter) {
            context.go('/books/$bookId/subchapters/${previousEntry.id}');
          } else {
            context.go('/books/$bookId/chapters/${previousEntry.id}');
          }
        }

        Future? nextPage() async {
          final entries = await orderedEntries();
          final currentIndex = entries.indexWhere(
            (entry) => entry.id == resource.id,
          );

          if (currentIndex == -1 || currentIndex + 1 >= entries.length) return;

          final nextEntry = entries[currentIndex + 1];
          if (nextEntry is BookSubchapter) {
            context.go('/books/$bookId/subchapters/${nextEntry.id}');
          } else {
            context.go('/books/$bookId/chapters/${nextEntry.id}');
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
              onBackPressed: () async => context.go('/books/$bookId'),
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

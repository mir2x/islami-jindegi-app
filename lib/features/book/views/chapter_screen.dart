import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
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
import '../models/book_node_ref.dart';
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
        // A header chapter carries no reading order — it is a table-of-contents
        // node, not a navigable page. Send the reader to its first descendant.
        final readingOrder = resource.readingOrder;
        if (readingOrder == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.go(resource.subchapters.isNotEmpty
                ? '/books/$bookId/subchapters/${resource.subchapters.first.id}'
                : '/books/$bookId');
          });
          return const FullScreenLoader();
        }

        Future<BookNodeRef?> sibling(bool forward) async =>
            (forward ? resource.next : resource.previous) ??
            (!resource.isOffline
                ? null
                : await ref
                    .read(bookOfflineServiceProvider)
                    .findBookNodeSibling(
                        bookId: bookId,
                        readingOrder: readingOrder,
                        forward: forward));

        String routeFor(BookNodeRef node) => node.kind == 'subchapter'
            ? '/books/$bookId/subchapters/${node.id}'
            : '/books/$bookId/chapters/${node.id}';

        Future? previousPage() async {
          final previous = await sibling(false);
          if (!context.mounted) return;
          context.go(
              previous == null ? '/books/$bookId' : routeFor(previous));
        }

        Future? nextPage() async {
          final next = await sibling(true);
          if (!context.mounted || next == null) return;
          context.go(routeFor(next));
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
              title: Text(ref.watch(bookDetailProvider(bookId)).value?.title ??
                  locales.book),
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
                          arabicFontScale: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              bottomBar: BottomBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Previous(
                    onPrevious: previousPage,
                    resolveDisabledKey: resource.id,
                    resolveDisabled: () async => await sibling(false) == null,
                  ),
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
                  Next(
                    onNext: nextPage,
                    resolveDisabledKey: resource.id,
                    resolveDisabled: () async => await sibling(true) == null,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

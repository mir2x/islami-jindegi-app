import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
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

class Chapter extends ConsumerWidget {
  const Chapter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;

    var query = SingleModelQuery(
      repository: ref.chapters,
      id: QR.params['chapter_id'].toString(),
    );

    var bookId = QR.params['id'];

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          var previousResources = await ref.chapters.findAll(
            params: {
              'quantity': 1,
              'include': 'subchapters',
              'bookId': bookId,
              'position': resource.position - 1,
            },
          );

          if (previousResources.isEmpty) {
            await QR.to('books/$bookId');
          } else {
            var subchapters = previousResources.first.subchapters;

            if (subchapters != null && subchapters.isNotEmpty) {
              var lastSubchapter = subchapters.map((a) => a).last;

              await QR.to(
                'books/$bookId/subchapters/${lastSubchapter.id}',
              );
            } else {
              await QR.to(
                'books/$bookId/chapters/${previousResources.first.id}',
              );
            }
          }
        }

        Future? nextPage() async {
          var nextResources = await ref.chapters.findAll(
            params: {
              'quantity': 1,
              'include': 'subchapters',
              'bookId': bookId,
              'position': resource.position + 1,
            },
          );

          if (nextResources.isNotEmpty) {
            var subchapters = nextResources.first.subchapters;

            if (subchapters != null && subchapters.isNotEmpty) {
              await QR.to(
                'books/$bookId/subchapters/${subchapters.first.id}',
              );
            } else {
              await QR.to(
                'books/$bookId/chapters/${nextResources.first.id}',
              );
            }
          }
        }

        return ResizableFont(
          storeKey: 'bookFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await QR.to('books/$bookId'),
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: PageHtmlBody(
                        text: resource.body,
                        fontSizeRatio: fontSizeRatio,
                      ),
                    ),
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

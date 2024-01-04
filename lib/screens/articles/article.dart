import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/full_screen_loader.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/download_item.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';

class Article extends ConsumerWidget {
  const Article({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;

    var query = SingleModelQuery(
      repository: ref.articles,
      id: QR.params['id'].toString(),
      params: const {'include': 'article-author'},
    );

    var modelQuery = ref.watch(singleModelProvider(query));

    return modelQuery.when(
      loading: () => const FullScreenLoader(),
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        Future? previousPage() async {
          var previousResources = await ref.articles.findAll(
            params: {
              'quantity': 1,
              'include': 'article-author',
              'position': resource.position - 1,
            },
          );

          if (previousResources.isEmpty) {
            await QR.to('articles');
          } else {
            await QR.to('articles/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          var nextResources = await ref.articles.findAll(
            params: {
              'quantity': 1,
              'include': 'article-author',
              'position': resource.position + 1,
            },
          );

          if (nextResources.isNotEmpty) {
            await QR.to('articles/${nextResources.first.id}');
          }
        }

        ref.read(lastVisitedProvider.notifier).updateLastArticle(resource.id);

        return ResizableFont(
          storeKey: 'articleFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async => await QR.to('articles'),
              showPattern: false,
              title: Text(locales.article),
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
                    if (resource.articleAuthor.value != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: PageSubtitle(
                          text: resource.articleAuthor.value.name,
                          fontSizeRatio: fontSizeRatio,
                        ),
                      ),
                    ],
                    if (resource.document != null) ...[
                      DownloadItem(
                        filePath: resource.document['id'],
                        fileUrl: fileSrcUrl(resource.document),
                        textWidth: 110,
                        downloadedTextWidth: 125,
                      ),
                    ],
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
                        subtitle: resource.articleAuthor.value?.name,
                        body: resource.body,
                        link: 'articles/${resource.id}',
                      ),
                      BookmarkButton(
                        type: 'Article',
                        title: resource.title,
                        link: 'articles/${resource.id}',
                      ),
                    ],
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'articleFontRatio',
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

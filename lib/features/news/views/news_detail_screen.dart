import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/presentation/resizable_font.dart';
import 'package:native_app/widgets/gestures/next_page_swipe.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/page/title.dart';
import 'package:native_app/widgets/page/subtitle.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/social_share.dart';
import 'package:native_app/widgets/buttons/bookmark.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/buttons/previous.dart';
import 'package:native_app/widgets/buttons/next.dart';
import '../providers/news_providers.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var newsId = GoRouterState.of(context).pathParameters['id'].toString();
    var newsQuery = ref.watch(singleNewsProvider(newsId));

    return newsQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resource) {
        final api = ref.read(newsApiServiceProvider);

        Future? previousPage() async {
          var previousResources = await api.fetchNewsByGtPublishedAt(
            quantity: 1,
            gtPublishedAt: resource.publishedAt,
          );

          if (previousResources.isEmpty) {
            if (context.canPop()) context.pop();
          } else {
            await context.push('/news/${previousResources.first.id}');
          }
        }

        Future? nextPage() async {
          var nextResources = await api.fetchNewsByLtPublishedAt(
            quantity: 1,
            ltPublishedAt: resource.publishedAt,
          );

          if (nextResources.isNotEmpty) {
            await context.push('/news/${nextResources.first.id}');
          }
        }

        Future(() {
          ref.read(lastVisitedProvider.notifier).updateLastNews(resource.id);
        });

        return ResizableFont(
          storeKey: 'newsFontRatio',
          builder: (context, fontSizeRatio) {
            return AppScaffold(
              onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/news'); },
              showPattern: false,
              title: Text(locales.news),
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
                      margin: const EdgeInsets.only(bottom: 15),
                      child: PageSubtitle(
                        text: formatDate(resource.publishedAt, currentLang),
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
                        link: 'news/${resource.id}',
                      ),
                      BookmarkButton(
                        type: 'News',
                        title: resource.title,
                        link: 'news/${resource.id}',
                      ),
                    ],
                  ),
                  FontResizer(
                    fontSizeRatio: fontSizeRatio,
                    storeKey: 'newsFontRatio',
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

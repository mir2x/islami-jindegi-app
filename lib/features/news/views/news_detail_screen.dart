import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
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
import '../models/news.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key});

  Future<NewsItem?> _findAdjacentNews(
    WidgetRef ref,
    NewsItem current, {
    required bool next,
  }) async {
    try {
      final orderedIds = await ref.read(newsNavigationIdsProvider.future);
      final currentIndex = orderedIds.indexOf(current.id);
      if (currentIndex == -1) return null;

      final targetIndex = next ? currentIndex + 1 : currentIndex - 1;
      if (targetIndex < 0 || targetIndex >= orderedIds.length) return null;

      final targetId = orderedIds[targetIndex];
      final api = ref.read(newsApiServiceProvider);
      return await api.fetchSingleNews(targetId);
    } catch (_) {
      return null;
    }
  }

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
        Future? previousPage() async {
          final previous = await _findAdjacentNews(ref, resource, next: false);
          if (previous == null) {
            if (context.canPop()) context.pop();
          } else {
            await context.push('/news/${previous.id}');
          }
        }

        Future? nextPage() async {
          final next = await _findAdjacentNews(ref, resource, next: true);
          if (next != null) {
            await context.push('/news/${next.id}');
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
                        text: resource.body ?? '',
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

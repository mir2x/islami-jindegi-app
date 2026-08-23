import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/widgets/presentation/continue_reading_card.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import '../providers/news_providers.dart';
import '../providers/news_progress_provider.dart';

class NewsListScreen extends ConsumerStatefulWidget {
  const NewsListScreen({super.key});

  @override
  ConsumerState<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends ConsumerState<NewsListScreen> {
  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var appTheme = Theme.of(context).extension<AppThemeColors>()!;
    var qParams = ref.watch(newsQueryParamsProvider);
    final listState = ref.watch(newsListStateProvider(
      RetainedListKey(Map.unmodifiable(Map<String, dynamic>.from(qParams))),
    ),);
    WidgetsBinding.instance.addPostFrameCallback((_) => listState.restore());
    final progress = ref.watch(newsProgressProvider);
    final lastNewsId = progress?.id;

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      title: Text(locales.news),
      body: WithConnectivity(
        builder: (context, isConnected) {
          if (isConnected) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: appTheme.cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: appTheme.divider),
                  ),
                  child: SearchButtonField(
                    value: qParams['search'],
                    onUpdate: (value) {
                      ref
                          .read(newsQueryParamsProvider.notifier)
                          .updateParams('search', value);
                    },
                  ),
                ),
                if (progress != null)
                  ContinueReadingCard(
                      title: progress.title,
                      destination: '/news/${progress.id}',
                      icon: Icons.newspaper_outlined,),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InfiniteList(
                      qParams: qParams,
                      controller: listState.controller,
                      scrollController: listState.scrollController,
                      resourceFetcher: (Map<String, dynamic> params) async {
                        final api = ref.read(newsApiServiceProvider);
                        return await api.fetchNews(
                          page: params['page'] ?? 1,
                          perPage: params['per_page'] ?? 9,
                          search: qParams['search'],
                        );
                      },
                      itemBuilder: (_, item, __) {
                        final isRecent = item.id == lastNewsId;
                        return InkWell(
                          onTap: () => context.push('/news/${item.id}'),
                          child: ListItem(
                            recentlyVisited: isRecent,
                            item: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: textTheme.titleMedium,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          formatDate(
                                            item.publishedAt,
                                            currentLang,
                                          ),
                                          style: textTheme.labelSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                locales.connectToInternetMsg,
                style: textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

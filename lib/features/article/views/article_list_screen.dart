import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/helpers/date_range_filter.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/date.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/presentation/content_list_card.dart';
import 'package:native_app/widgets/presentation/continue_reading_card.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import '../providers/article_providers.dart';
import '../providers/article_progress_provider.dart';

class ArticleListScreen extends ConsumerStatefulWidget {
  const ArticleListScreen({super.key});

  @override
  ConsumerState<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends ConsumerState<ArticleListScreen> {
  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(articleQueryParamsProvider);
    // Presets ('past month') are resolved to concrete days here so the
    // API and the offline database receive identical bounds.
    final dateRange = DateRangeFilter.of(qParams);
    final listState = ref.watch(articleListStateProvider(
      RetainedListKey(Map.unmodifiable(Map<String, dynamic>.from(qParams))),
    ),);
    WidgetsBinding.instance.addPostFrameCallback((_) => listState.restore());
    final progress = ref.watch(articleProgressProvider);
    final lastArticleId = progress?.id;

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      title: Text(locales.articles),
      body: OfflineDbPrompt(
        feature: 'articles',
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilterButton(
                          label: locales.authors,
                          active: qParams.containsKey('articleAuthorId'),
                          onClear: () {
                            ref
                                .read(articleQueryParamsProvider.notifier)
                                .updateParams('articleAuthorId', '');
                          },
                          selectedItemProvider:
                              qParams.containsKey('articleAuthorId')
                                  ? singleArticleAuthorProvider(
                                      qParams['articleAuthorId'],
                                    )
                                  : null,
                          selectedItemLabel: (dynamic item) {
                            return item.name;
                          },
                          children: [
                            Expanded(
                              child: FilterList(
                                title: locales.authors,
                                paramKeys: const ['articleAuthorId'],
                                searchEnabled: true,
                                queryProvider: articleQueryParamsProvider,
                                resourceFetcher:
                                    (Map<String, dynamic> params) async {
                                  final api =
                                      ref.read(articleApiServiceProvider);
                                  final offline =
                                      ref.read(articleOfflineServiceProvider);
                                  try {
                                    return await api.fetchAuthors(
                                      page: params['page'] ?? 1,
                                      perPage: params['per_page'] ?? 16,
                                      search: params['search'],
                                    );
                                  } catch (_) {
                                    return await offline.queryAuthors(
                                      page: params['page'] ?? 1,
                                      perPage: params['per_page'] ?? 16,
                                      search: params['search'],
                                    );
                                  }
                                },
                                itemBuilder: (_, item, __) {
                                  return FilterItem(
                                    itemId: item.id,
                                    itemTitle: item.name,
                                    paramKey: 'articleAuthorId',
                                    queryProvider: articleQueryParamsProvider,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: FilterButton(
                          label: locales.categories,
                          active: qParams.containsKey('categoryId'),
                          onClear: () {
                            ref
                                .read(
                                  articleQueryParamsProvider.notifier,
                                )
                                .updateParams('categoryId', '');
                          },
                          selectedItemProvider:
                              qParams.containsKey('categoryId')
                                  ? singleArticleCategoryProvider(
                                      qParams['categoryId'],
                                    )
                                  : null,
                          selectedItemLabel: (dynamic item) {
                            return item.title;
                          },
                          children: [
                            Expanded(
                              child: FilterList(
                                title: locales.categories,
                                paramKeys: const ['categoryId'],
                                searchEnabled: true,
                                queryProvider: articleQueryParamsProvider,
                                resourceFetcher: (
                                  Map<String, dynamic> params,
                                ) async {
                                  final api = ref.read(
                                    articleApiServiceProvider,
                                  );
                                  final offline = ref.read(
                                    articleOfflineServiceProvider,
                                  );
                                  try {
                                    return await api.fetchCategories(
                                      page: params['page'] ?? 1,
                                      perPage: params['per_page'] ?? 16,
                                      search: params['search'],
                                    );
                                  } catch (_) {
                                    return await offline.queryCategories(
                                      page: params['page'] ?? 1,
                                      perPage: params['per_page'] ?? 16,
                                      search: params['search'],
                                    );
                                  }
                                },
                                itemBuilder: (_, item, __) {
                                  return FilterItem(
                                    itemId: item.id,
                                    itemTitle: item.title,
                                    paramKey: 'categoryId',
                                    queryProvider: articleQueryParamsProvider,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: DateFilter(
                          queryProvider: articleQueryParamsProvider,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SearchButtonField(
                          value: qParams['search'],
                          onUpdate: (value) {
                            ref
                                .read(articleQueryParamsProvider.notifier)
                                .updateParams('search', value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (progress != null)
              ContinueReadingCard(
                  title: progress.title,
                  destination: '/articles/${progress.id}',
                  icon: Icons.article_outlined,),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  controller: listState.controller,
                  scrollController: listState.scrollController,
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(articleApiServiceProvider);
                    final offline = ref.read(articleOfflineServiceProvider);
                    try {
                      return await api.fetchArticles(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        articleAuthorId: qParams['articleAuthorId'],
                        articleCategoryId: qParams['categoryId'],
                        dateFrom: dateRange.from,
                        dateTo: dateRange.to,
                      );
                    } catch (_) {
                      return await offline.queryArticles(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        articleAuthorId: qParams['articleAuthorId'],
                        articleCategoryId: qParams['categoryId'],
                        dateFrom: dateRange.from,
                        dateTo: dateRange.to,
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastArticleId;
                    return InkWell(
                      onTap: () => context.push('/articles/${item.id}'),
                      child: ContentListCard(
                        recentlyVisited: isRecent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: textTheme.titleMedium?.copyWith(
                                      height: 1.25,
                                    ),
                                  ),
                                  if (item.authorName != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        item.authorName!,
                                        style: textTheme.labelSmall?.copyWith(
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/nested_item.dart';
import 'package:native_app/widgets/filter/subitem.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import '../providers/article_providers.dart';

class ArticleListScreen extends ConsumerWidget {
  const ArticleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(articleQueryParamsProvider);

    return AppScaffold(
      title: Text(locales.articles),
      body: Column(
        children: [
          WithConnectivity(
            builder: (context, isConnected) {
              if (isConnected) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 20, left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: FilterButton(
                              label: locales.authors,
                              active: qParams.containsKey('articleAuthorId'),
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
                                      return await api.fetchAuthors(
                                        page: params['page'] ?? 1,
                                        perPage: params['per_page'] ?? 16,
                                        search: params['search'],
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.name,
                                        paramKey: 'articleAuthorId',
                                        queryProvider:
                                            articleQueryParamsProvider,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                dynamic selectedProvider;

                                if (qParams.containsKey('articleCategoryId')) {
                                  selectedProvider =
                                      singleArticleCategoryProvider(
                                    qParams['articleCategoryId'],
                                  );
                                } else if (qParams
                                    .containsKey('articleSubcategoryId')) {
                                  selectedProvider =
                                      singleArticleSubcategoryProvider(
                                    qParams['articleSubcategoryId'],
                                  );
                                }

                                return FilterButton(
                                  label: locales.categories,
                                  active: qParams.keys.any(
                                    (k) => [
                                      'articleCategoryId',
                                      'articleSubcategoryId',
                                    ].contains(k),
                                  ),
                                  selectedItemProvider: selectedProvider,
                                  selectedItemLabel: (dynamic item) {
                                    return item.title;
                                  },
                                  children: [
                                    Expanded(
                                      child: FilterList(
                                        title: locales.categories,
                                        paramKeys: const [
                                          'articleCategoryId',
                                          'articleSubcategoryId',
                                        ],
                                        queryProvider:
                                            articleQueryParamsProvider,
                                        resourceFetcher: (Map<String, dynamic>
                                            params) async {
                                          final api = ref
                                              .read(articleApiServiceProvider);
                                          return await api.fetchCategories(
                                            page: params['page'] ?? 1,
                                            perPage: params['per_page'] ?? 16,
                                            search: params['search'],
                                          );
                                        },
                                        itemBuilder: (_, item, __) {
                                          if (item.articleSubcategories.length >
                                              0) {
                                            return FilterNestedItem(
                                              itemId: item.id,
                                              itemTitle: item.title,
                                              paramKey: 'articleSubcategoryId',
                                              subitems:
                                                  item.articleSubcategories,
                                              queryProvider:
                                                  articleQueryParamsProvider,
                                              subitemBuilder: (var subitem) {
                                                return FilterSubitem(
                                                  itemId: subitem.id,
                                                  itemTitle: subitem.title,
                                                  paramKey:
                                                      'articleSubcategoryId',
                                                  queryProvider:
                                                      articleQueryParamsProvider,
                                                );
                                              },
                                            );
                                          } else {
                                            return FilterItem(
                                              itemId: item.id,
                                              itemTitle: item.title,
                                              paramKey: 'articleCategoryId',
                                              queryProvider:
                                                  articleQueryParamsProvider,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
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
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InfiniteList(
                qParams: qParams,
                resourceFetcher: (Map<String, dynamic> params) async {
                  final api = ref.read(articleApiServiceProvider);
                  final offline = ref.read(articleOfflineServiceProvider);
                  try {
                    return await api.fetchArticles(
                      page: params['page'] ?? 1,
                      perPage: params['per_page'] ?? 9,
                      search: qParams['search'],
                      articleAuthorId: qParams['articleAuthorId'],
                      articleCategoryId: qParams['articleCategoryId'],
                      articleSubcategoryId: qParams['articleSubcategoryId'],
                    );
                  } catch (_) {
                    return await offline.queryArticles(
                      page: params['page'] ?? 1,
                      perPage: params['per_page'] ?? 9,
                      search: qParams['search'],
                      articleAuthorId: qParams['articleAuthorId'],
                      articleCategoryId: qParams['articleCategoryId'],
                      articleSubcategoryId: qParams['articleSubcategoryId'],
                    );
                  }
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('articles/${item.id}'),
                    child: ListItem(
                      item: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: textTheme.titleMedium,
                                ),
                                if (item.authorName != null) ...[
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      item.authorName!,
                                      style: textTheme.labelSmall,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          LastVisited(
                            resourceKey: 'lastArticle',
                            resourceId: item.id,
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
    );
  }
}

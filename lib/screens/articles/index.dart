import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/nested_item.dart';
import 'package:native_app/widgets/filter/subitem.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class Articles extends ConsumerWidget {
  const Articles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);
    final connectivity = ref.watch(connectivityResultProvider);

    return MyScaffold(
      title: Text(locales.articles),
      body: Column(
        children: [
          connectivity.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (connectivityResult) {
              if (connectivityResult != ConnectivityResult.none) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilterButton(
                          active: qParams.keys.any(
                            (k) => [
                              'articleCategoryId',
                              'articleSubcategoryId',
                              'articleAuthorId'
                            ].contains(k),
                          ),
                          children: [
                            Expanded(
                              child: FilterList(
                                title: locales.categories,
                                paramKeys: const [
                                  'articleCategoryId',
                                  'articleSubcategoryId'
                                ],
                                queryBuilder: (Map<String, dynamic> params) {
                                  return AllModelsQuery(
                                    repository: ref.articleCategories,
                                    params: {
                                      ...params,
                                      'include': 'article-subcategories'
                                    },
                                  );
                                },
                                itemBuilder: (_, item, __) {
                                  if (item.articleSubcategories.length > 0) {
                                    return FilterNestedItem(
                                      itemTitle: item.title,
                                      paramKey: 'articleSubcategoryId',
                                      subitems: item.articleSubcategories,
                                      subitemBuilder: (var subitem) {
                                        return FilterSubitem(
                                          itemId: subitem.id,
                                          itemTitle: subitem.title,
                                          paramKey: 'articleSubcategoryId',
                                        );
                                      },
                                    );
                                  } else {
                                    return FilterItem(
                                      itemId: item.id,
                                      itemTitle: item.title,
                                      paramKey: 'articleCategoryId',
                                    );
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 40),
                            Expanded(
                              child: FilterList(
                                title: locales.authors,
                                paramKeys: const ['articleAuthorId'],
                                queryBuilder: (Map<String, dynamic> params) {
                                  return AllModelsQuery(
                                    repository: ref.articleAuthors,
                                    params: params,
                                  );
                                },
                                itemBuilder: (_, item, __) {
                                  return FilterItem(
                                    itemId: item.id,
                                    itemTitle: item.name,
                                    paramKey: 'articleAuthorId',
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: SearchField(
                          value: qParams['search'],
                          onUpdate: (value) {
                            ref
                                .read(queryParamsProvider.notifier)
                                .updateParams('search', value);
                          },
                        ),
                      ),
                    ],
                  ),
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
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.articles,
                    params: {
                      ...params,
                      'include': 'article-author',
                    },
                  );

                  return await ref.read(allModelsProvider(query).future);
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('articles/${item.id}'),
                    child: ListItem(
                      item: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.titleMedium,
                          ),
                          if (item.articleAuthor.value != null) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                item.articleAuthor.value.name,
                                style: textTheme.labelSmall,
                              ),
                            ),
                          ],
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/nested_item.dart';
import 'package:native_app/widgets/filter/subitem.dart';
import 'package:native_app/widgets/filter/triple_switch_button.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class Malfuzat extends ConsumerWidget {
  const Malfuzat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);
    var connectivity = ref.watch(connectivityResultProvider);

    return AppScaffold(
      title: Text(locales.malfuzat),
      body: Column(
        children: [
          connectivity.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (connectivityResult) {
              if (connectivityResult != ConnectivityResult.none) {
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
                              active: qParams.keys.any(
                                (k) => [
                                  'malfuzatCategoryId',
                                  'malfuzatSubcategoryId',
                                  'malfuzatAuthorId'
                                ].contains(k),
                              ),
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.categories,
                                    paramKeys: const [
                                      'malfuzatCategoryId',
                                      'malfuzatSubcategoryId'
                                    ],
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.malfuzatCategories,
                                        params: {
                                          ...params,
                                          'include': 'malfuzat-subcategories'
                                        },
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      if (item.malfuzatSubcategories.length >
                                          0) {
                                        return FilterNestedItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'malfuzatSubcategoryId',
                                          subitems: item.malfuzatSubcategories,
                                          subitemBuilder: (var subitem) {
                                            return FilterSubitem(
                                              itemId: subitem.id,
                                              itemTitle: subitem.title,
                                              paramKey: 'malfuzatSubcategoryId',
                                            );
                                          },
                                        );
                                      } else {
                                        return FilterItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'malfuzatCategoryId',
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Expanded(
                                  child: FilterList(
                                    title: locales.authors,
                                    paramKeys: const ['malfuzatAuthorId'],
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.malfuzatAuthors,
                                        params: params,
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.name,
                                        paramKey: 'malfuzatAuthorId',
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
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 10,
                        bottom: 5,
                      ),
                      child: TripleSwitchButton(
                        firstLabel: locales.all,
                        secondLabel: locales.text,
                        thirdLabel: locales.audio,
                        activateFirst: () {
                          ref
                              .read(
                                queryParamsProvider.notifier,
                              )
                              .updateParams(
                                'hasAudio',
                                '',
                              );
                        },
                        activateSecond: () {
                          ref
                              .read(
                                queryParamsProvider.notifier,
                              )
                              .updateParams(
                                'hasAudio',
                                'false',
                              );
                        },
                        activateThird: () {
                          ref
                              .read(
                                queryParamsProvider.notifier,
                              )
                              .updateParams(
                                'hasAudio',
                                'true',
                              );
                        },
                        isFirstActive: !qParams.containsKey('hasAudio'),
                        isSecondActive: qParams.containsKey('hasAudio') &&
                            qParams['hasAudio'] == 'false',
                        isThirdActive: qParams.containsKey('hasAudio') &&
                            qParams['hasAudio'] == 'true',
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
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.malfuzats,
                    params: {
                      ...params,
                      'published': true,
                      'include': 'malfuzat-author',
                    },
                  );

                  return await ref.read(allModelsProvider(query).future);
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('malfuzat/${item.id}'),
                    child: ListItem(
                      item: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.titleMedium,
                          ),
                          if (item.malfuzatAuthor.value != null) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                item.malfuzatAuthor.value.name,
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

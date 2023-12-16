import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/first_model.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/nested_item.dart';
import 'package:native_app/widgets/filter/subitem.dart';
import 'package:native_app/widgets/filter/triple_switch_button.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/theme/colors.dart';

class Masail extends ConsumerWidget {
  const Masail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    var query = AllModelsQuery(
      repository: ref.settings,
      params: const {'quantity': 1},
    );

    var settingsQuery = ref.watch(firstModelProvider(query));

    return AppScaffold(
      title: Text(locales.masail),
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
                              active: qParams.keys.any(
                                (k) => [
                                  'masailAuthorId',
                                  'masailCategoryId',
                                  'masailSubcategoryId',
                                ].contains(k),
                              ),
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.authors,
                                    paramKeys: const ['masailAuthorId'],
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.masailAuthors,
                                        params: params,
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.name,
                                        paramKey: 'masailAuthorId',
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Expanded(
                                  child: FilterList(
                                    title: locales.categories,
                                    paramKeys: const [
                                      'masailCategoryId',
                                      'masailSubcategoryId',
                                    ],
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.masailCategories,
                                        params: {
                                          ...params,
                                          'include': 'masail-subcategories',
                                        },
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      if (item.masailSubcategories.length > 0) {
                                        return FilterNestedItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'masailSubcategoryId',
                                          subitems: item.masailSubcategories,
                                          subitemBuilder: (var subitem) {
                                            return FilterSubitem(
                                              itemId: subitem.id,
                                              itemTitle: subitem.title,
                                              paramKey: 'masailSubcategoryId',
                                            );
                                          },
                                        );
                                      } else {
                                        return FilterItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'masailCategoryId',
                                        );
                                      }
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
                            child: SearchButtonField(
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
                    repository: ref.masails,
                    params: {
                      ...params,
                      'published': true,
                      'include': 'masail-author',
                    },
                  );

                  return await ref.watch(allModelsProvider(query).future);
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('masail/${item.id}'),
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
                                if (item.masailAuthor.value != null) ...[
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      item.masailAuthor.value.name,
                                      style: textTheme.labelSmall,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          LastVisited(
                            resourceKey: 'lastMasail',
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          settingsQuery.when(
            loading: () => const SizedBox.shrink(),
            error: (error, _) => const SizedBox.shrink(),
            data: (settings) {
              if (settings.askQuestion) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: 170,
                    height: 40,
                    child: FloatingActionButton.extended(
                      onPressed: () => QR.to('masail/ask-question'),
                      icon: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ThemeColors.color4),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(Icons.question_mark, size: 18),
                      ),
                      label: Text(
                        locales.askQuestion,
                        style: textTheme.labelMedium,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: FloatingActionButton.extended(
              onPressed: () => QR.to('masail/downloads'),
              icon: const Icon(Icons.download),
              label: Text(
                '${locales.downloaded} ${locales.masail}',
                style: textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

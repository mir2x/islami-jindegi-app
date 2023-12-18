import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/date.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/widgets/utils/last_visited.dart';

class Bayans extends ConsumerWidget {
  const Bayans({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    return AppScaffold(
      title: Text(locales.bayans),
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
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: FilterButton(
                              label: locales.speakers,
                              active: qParams.containsKey('speakerId'),
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.speakers,
                                    paramKeys: const ['speakerId'],
                                    pageSize: 16,
                                    searchEnabled: true,
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.speakers,
                                        params: params,
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.name,
                                        paramKey: 'speakerId',
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
                            child: FilterButton(
                              label: locales.categories,
                              active: qParams.containsKey('bayanCategoryId'),
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.categories,
                                    paramKeys: const ['bayanCategoryId'],
                                    pageSize: 16,
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.bayanCategories,
                                        params: params,
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.title,
                                        paramKey: 'bayanCategoryId',
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
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Row(
                        children: [
                          const Expanded(
                            child: DateFilter(),
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
                pageSize: 9,
                qParams: qParams,
                resourceFetcher: (Map<String, dynamic> params) async {
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.bayans,
                    params: {
                      ...params,
                      'published': true,
                      'include': 'speaker',
                    },
                  );

                  return await ref.watch(allModelsProvider(query).future);
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('bayans/${item.id}'),
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
                                if (item.speaker.value != null) ...[
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      item.speaker.value.name,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                                if (item.location != null) ...[
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      item.location,
                                      style: textTheme.labelSmall,
                                    ),
                                  ),
                                ],
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    formatDate(item.publishedAt, currentLang),
                                    style: textTheme.labelSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LastVisited(
                            resourceKey: 'lastBayan',
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
      floatingActionButton: SizedBox(
        width: 200,
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () => QR.to('bayans/downloads'),
          icon: const Icon(Icons.download),
          label: Text(
            '${locales.downloaded} ${locales.bayans}',
            style: textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}

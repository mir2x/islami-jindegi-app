import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/date.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/widgets/buttons/floating_downloaded.dart';
import '../providers/bayan_providers.dart';

class BayanListScreen extends ConsumerWidget {
  const BayanListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(bayanQueryParamsProvider);

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
                              selectedItemProvider:
                                  qParams.containsKey('speakerId')
                                      ? singleSpeakerProvider(
                                          qParams['speakerId'],
                                        )
                                      : null,
                              selectedItemLabel: (dynamic item) {
                                return item.name;
                              },
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.speakers,
                                    paramKeys: const ['speakerId'],
                                    pageSize: 16,
                                    searchEnabled: true,
                                    queryProvider: bayanQueryParamsProvider,
                                    resourceFetcher:
                                        (Map<String, dynamic> params) async {
                                      final api =
                                          ref.read(bayanApiServiceProvider);
                                      return await api.fetchSpeakers(
                                        page: params['page'] ?? 1,
                                        perPage: params['per_page'] ?? 16,
                                        search: params['search'],
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.name,
                                        paramKey: 'speakerId',
                                        queryProvider: bayanQueryParamsProvider,
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
                              active: qParams.containsKey('bayanCategoryId'),
                              selectedItemProvider:
                                  qParams.containsKey('bayanCategoryId')
                                      ? singleBayanCategoryProvider(
                                          qParams['bayanCategoryId'],
                                        )
                                      : null,
                              selectedItemLabel: (dynamic item) {
                                return item.title;
                              },
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.categories,
                                    paramKeys: const ['bayanCategoryId'],
                                    pageSize: 16,
                                    queryProvider: bayanQueryParamsProvider,
                                    resourceFetcher:
                                        (Map<String, dynamic> params) async {
                                      final api =
                                          ref.read(bayanApiServiceProvider);
                                      return await api.fetchBayanCategories(
                                        page: params['page'] ?? 1,
                                        perPage: params['per_page'] ?? 16,
                                        search: params['search'],
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.title,
                                        paramKey: 'bayanCategoryId',
                                        queryProvider: bayanQueryParamsProvider,
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
                          Expanded(
                            child: DateFilter(
                              queryProvider: bayanQueryParamsProvider,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: SearchButtonField(
                              value: qParams['search'],
                              onUpdate: (value) {
                                ref
                                    .read(bayanQueryParamsProvider.notifier)
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
                  final api = ref.read(bayanApiServiceProvider);
                  return await api.fetchBayans(
                    page: params['page'] ?? 1,
                    perPage: params['per_page'] ?? 9,
                    search: qParams['search'],
                    speakerId: qParams['speakerId'],
                    bayanCategoryId: qParams['bayanCategoryId'],
                    dateRange: qParams['dateRange'],
                    dateFrom: qParams['dateFrom'],
                    dateTo: qParams['dateTo'],
                  );
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('bayans/${item.id}'),
                    child: ListItem(
                      highlightProvider: getDownloadedBayanByIdProvider(
                        item.id,
                      ),
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
                                if (item.speakerName != null) ...[
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      item.speakerName!,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                                if (item.location != null) ...[
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      item.location!,
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
        child: FloatingDownloadedButton(
          onPressed: () => QR.to('bayans/downloads'),
          label: '${locales.downloaded} ${locales.bayans}',
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/nested_item.dart';
import 'package:native_app/widgets/filter/subitem.dart';
import 'package:native_app/widgets/filter/triple_switch_button.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/providers/downloaded_malfuzat.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/widgets/buttons/floating_downloaded.dart';
import '../providers/malfuzat_providers.dart';

class MalfuzatListScreen extends ConsumerWidget {
  const MalfuzatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(malfuzatQueryParamsProvider);

    return AppScaffold(
      onBackPressed: () async => context.go('/'),
      title: Text(locales.malfuzat),
      body: OfflineDbPrompt(
        feature: 'malfuzats',
        child: Column(
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
                                label: locales.authorsOrSpeakers,
                                active: qParams.containsKey('malfuzatAuthorId'),
                                selectedItemProvider:
                                    qParams.containsKey('malfuzatAuthorId')
                                        ? singleMalfuzatAuthorProvider(
                                            qParams['malfuzatAuthorId'],
                                          )
                                        : null,
                                selectedItemLabel: (dynamic item) {
                                  return item.name;
                                },
                                children: [
                                  Expanded(
                                    child: FilterList(
                                      title: locales.authorsOrSpeakers,
                                      paramKeys: const ['malfuzatAuthorId'],
                                      searchEnabled: true,
                                      queryProvider:
                                          malfuzatQueryParamsProvider,
                                      resourceFetcher:
                                          (Map<String, dynamic> params) async {
                                        final api = ref
                                            .read(malfuzatApiServiceProvider);
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
                                          paramKey: 'malfuzatAuthorId',
                                          queryProvider:
                                              malfuzatQueryParamsProvider,
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

                                  if (qParams
                                      .containsKey('malfuzatCategoryId')) {
                                    selectedProvider =
                                        singleMalfuzatCategoryProvider(
                                      qParams['malfuzatCategoryId'],
                                    );
                                  } else if (qParams
                                      .containsKey('malfuzatSubcategoryId')) {
                                    selectedProvider =
                                        singleMalfuzatSubcategoryProvider(
                                      qParams['malfuzatSubcategoryId'],
                                    );
                                  }

                                  return FilterButton(
                                    label: locales.categories,
                                    active: qParams.keys.any(
                                      (k) => [
                                        'malfuzatCategoryId',
                                        'malfuzatSubcategoryId',
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
                                            'malfuzatCategoryId',
                                            'malfuzatSubcategoryId',
                                          ],
                                          queryProvider:
                                              malfuzatQueryParamsProvider,
                                          resourceFetcher: (Map<String, dynamic>
                                              params) async {
                                            final api = ref.read(
                                                malfuzatApiServiceProvider);
                                            return await api.fetchCategories(
                                              page: params['page'] ?? 1,
                                              perPage: params['per_page'] ?? 16,
                                              search: params['search'],
                                            );
                                          },
                                          itemBuilder: (_, item, __) {
                                            if (item.malfuzatSubcategories
                                                    .length >
                                                0) {
                                              return FilterNestedItem(
                                                itemId: item.id,
                                                itemTitle: item.title,
                                                paramKey:
                                                    'malfuzatSubcategoryId',
                                                subitems:
                                                    item.malfuzatSubcategories,
                                                queryProvider:
                                                    malfuzatQueryParamsProvider,
                                                subitemBuilder: (var subitem) {
                                                  return FilterSubitem(
                                                    itemId: subitem.id,
                                                    itemTitle: subitem.title,
                                                    paramKey:
                                                        'malfuzatSubcategoryId',
                                                    queryProvider:
                                                        malfuzatQueryParamsProvider,
                                                  );
                                                },
                                              );
                                            } else {
                                              return FilterItem(
                                                itemId: item.id,
                                                itemTitle: item.title,
                                                paramKey: 'malfuzatCategoryId',
                                                queryProvider:
                                                    malfuzatQueryParamsProvider,
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
                                .read(malfuzatQueryParamsProvider.notifier)
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: TripleSwitchButton(
                firstLabel: locales.all,
                secondLabel: locales.text,
                thirdLabel: locales.audio,
                activateFirst: () {
                  ref
                      .read(malfuzatQueryParamsProvider.notifier)
                      .updateParams('hasAudio', '');
                },
                activateSecond: () {
                  ref
                      .read(malfuzatQueryParamsProvider.notifier)
                      .updateParams('hasAudio', 'false');
                },
                activateThird: () {
                  ref
                      .read(malfuzatQueryParamsProvider.notifier)
                      .updateParams('hasAudio', 'true');
                },
                isFirstActive: !qParams.containsKey('hasAudio'),
                isSecondActive: qParams.containsKey('hasAudio') &&
                    qParams['hasAudio'] == 'false',
                isThirdActive: qParams.containsKey('hasAudio') &&
                    qParams['hasAudio'] == 'true',
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(malfuzatApiServiceProvider);
                    final offline = ref.read(malfuzatOfflineServiceProvider);
                    try {
                      return await api.fetchMalfuzat(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        malfuzatAuthorId: qParams['malfuzatAuthorId'],
                        malfuzatCategoryId: qParams['malfuzatCategoryId'],
                        malfuzatSubcategoryId: qParams['malfuzatSubcategoryId'],
                        hasAudio: qParams['hasAudio'],
                      );
                    } catch (_) {
                      return await offline.queryMalfuzats(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        malfuzatAuthorId: qParams['malfuzatAuthorId'],
                        malfuzatCategoryId: qParams['malfuzatCategoryId'],
                        malfuzatSubcategoryId: qParams['malfuzatSubcategoryId'],
                        hasAudio: qParams['hasAudio'] == 'true'
                            ? true
                            : (qParams['hasAudio'] == 'false' ? false : null),
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    return InkWell(
                      onTap: () => context.push('/malfuzat/${item.id}'),
                      child: ListItem(
                        highlightProvider: getDownloadedMalfuzatByIdProvider(
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
                              resourceKey: 'lastMalfuzat',
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
      ),
      floatingActionButton: SizedBox(
        width: 220,
        height: 40,
        child: FloatingDownloadedButton(
          onPressed: () => context.push('/malfuzat/downloads'),
          label: '${locales.downloaded} ${locales.malfuzat}',
        ),
      ),
    );
  }
}

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
import 'package:native_app/widgets/filter/triple_switch_button.dart';
import 'package:native_app/widgets/presentation/content_list_card.dart';
import 'package:native_app/providers/downloaded_malfuzat.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import 'package:native_app/core/navigation/content_scope.dart';
import 'package:native_app/widgets/presentation/continue_reading_card.dart';
import '../providers/malfuzat_providers.dart';
import '../providers/malfuzat_progress_provider.dart';

class MalfuzatListScreen extends ConsumerStatefulWidget {
  const MalfuzatListScreen({super.key});

  @override
  ConsumerState<MalfuzatListScreen> createState() => _MalfuzatListScreenState();
}

class _MalfuzatListScreenState extends ConsumerState<MalfuzatListScreen> {
  /// The active tab lives in the query params notifier, which is `autoDispose`
  /// and dies with this route. Returning from a detail screen after Next/Prev
  /// (which uses `context.go`) rebuilds this screen from scratch, so the tab
  /// has to come back from the URL the detail screen navigated to.
  bool _seededScope = false;

  void _seedScopeFromUrl(BuildContext context) {
    if (_seededScope) return;
    _seededScope = true;
    final scope = ContentScope.fromQuery(
        GoRouterState.of(context).uri.queryParameters['scope']);
    if (scope == ContentScope.all) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(malfuzatQueryParamsProvider.notifier).updateParams(
            'hasAudio',
            scope == ContentScope.audio ? 'true' : 'false',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    _seedScopeFromUrl(context);
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(malfuzatQueryParamsProvider);
    // Presets ('past month') are resolved to concrete days here so the
    // API and the offline database receive identical bounds.
    final dateRange = DateRangeFilter.of(qParams);
    final listState = ref.watch(malfuzatListStateProvider(
      RetainedListKey(Map.unmodifiable(Map<String, dynamic>.from(qParams))),
    ));
    final progress = ref.watch(malfuzatProgressProvider);
    // One derivation feeds both the progress bucket and the URL the detail
    // screen will read its scope back from.
    final scope = ContentScope.fromQueryParams(qParams);
    final tab = switch (scope) {
      ContentScope.audio => MalfuzatTab.audio,
      ContentScope.text => MalfuzatTab.text,
      ContentScope.all => MalfuzatTab.all,
    };
    final tabProgress = progress[tab];
    final lastMalfuzatId = tabProgress?.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => listState.restore());

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop())
          context.pop();
        else
          context.go('/');
      },
      title: Text(locales.malfuzat),
      body: OfflineDbPrompt(
        feature: 'malfuzats',
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
                          label: locales.authorsOrSpeakers,
                          active: qParams.containsKey('authorId'),
                          onClear: () {
                            ref
                                .read(
                                  malfuzatQueryParamsProvider.notifier,
                                )
                                .updateParams('authorId', '');
                          },
                          selectedItemProvider: qParams.containsKey('authorId')
                              ? singleMalfuzatAuthorProvider(
                                  qParams['authorId'],
                                )
                              : null,
                          selectedItemLabel: (dynamic item) {
                            return item.name;
                          },
                          children: [
                            Expanded(
                              child: FilterList(
                                title: locales.authorsOrSpeakers,
                                paramKeys: const ['authorId'],
                                searchEnabled: true,
                                queryProvider: malfuzatQueryParamsProvider,
                                resourceFetcher:
                                    (Map<String, dynamic> params) async {
                                  final api =
                                      ref.read(malfuzatApiServiceProvider);
                                  final offline =
                                      ref.read(malfuzatOfflineServiceProvider);
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
                                    paramKey: 'authorId',
                                    queryProvider: malfuzatQueryParamsProvider,
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
                                  malfuzatQueryParamsProvider.notifier,
                                )
                                .updateParams('categoryId', '');
                          },
                          selectedItemProvider:
                              qParams.containsKey('categoryId')
                                  ? singleMalfuzatCategoryProvider(
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
                                queryProvider: malfuzatQueryParamsProvider,
                                resourceFetcher: (
                                  Map<String, dynamic> params,
                                ) async {
                                  final api = ref.read(
                                    malfuzatApiServiceProvider,
                                  );
                                  final offline = ref.read(
                                    malfuzatOfflineServiceProvider,
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
                                    queryProvider: malfuzatQueryParamsProvider,
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
                          queryProvider: malfuzatQueryParamsProvider,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
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
                  ),
                ),
              ],
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
            if (tabProgress != null)
              ContinueReadingCard(
                  title: tabProgress.title,
                  destination: scope.applyTo('/malfuzat/${tabProgress.id}'),
                  icon: Icons.menu_book_outlined),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  controller: listState.controller,
                  scrollController: listState.scrollController,
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(malfuzatApiServiceProvider);
                    final offline = ref.read(malfuzatOfflineServiceProvider);
                    final hasAudio = qParams['hasAudio'] == 'true'
                        ? true
                        : (qParams['hasAudio'] == 'false' ? false : null);
                    try {
                      return await api.fetchMalfuzat(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        authorId: qParams['authorId'],
                        categoryId: qParams['categoryId'],
                        hasAudio: hasAudio,
                        dateFrom: dateRange.from,
                        dateTo: dateRange.to,
                      );
                    } catch (_) {
                      return await offline.queryMalfuzats(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        authorId: qParams['authorId'],
                        categoryId: qParams['categoryId'],
                        hasAudio: hasAudio,
                        dateFrom: dateRange.from,
                        dateTo: dateRange.to,
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastMalfuzatId;
                    return InkWell(
                      onTap: () =>
                          context.push(scope.applyTo('/malfuzat/${item.id}')),
                      child: ContentListCard(
                        recentlyVisited: isRecent,
                        highlightProvider: getDownloadedMalfuzatByIdProvider(
                          item.id,
                        ),
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

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
import 'package:native_app/providers/downloaded_masail.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import 'package:native_app/core/navigation/content_scope.dart';
import 'package:native_app/widgets/presentation/continue_reading_card.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/masail_providers.dart';
import '../providers/masail_progress_provider.dart';

class MasailListScreen extends ConsumerStatefulWidget {
  const MasailListScreen({super.key});

  @override
  ConsumerState<MasailListScreen> createState() => _MasailListScreenState();
}

class _MasailListScreenState extends ConsumerState<MasailListScreen> {
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
      ref.read(masailQueryParamsProvider.notifier).updateParams(
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
    var qParams = ref.watch(masailQueryParamsProvider);
    // Presets ('past month') are resolved to concrete days here so the
    // API and the offline database receive identical bounds.
    final dateRange = DateRangeFilter.of(qParams);
    var settingsQuery = ref.watch(masailSettingsProvider);
    final listState = ref.watch(masailListStateProvider(
      RetainedListKey(Map.unmodifiable(Map<String, dynamic>.from(qParams))),
    ));
    final progress = ref.watch(masailProgressProvider);
    // One derivation feeds both the progress bucket and the URL the detail
    // screen will read its scope back from.
    final scope = ContentScope.fromQueryParams(qParams);
    final tab = switch (scope) {
      ContentScope.audio => MasailTab.audio,
      ContentScope.text => MasailTab.text,
      ContentScope.all => MasailTab.all,
    };
    final tabProgress = progress[tab];
    final lastMasailId = tabProgress?.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => listState.restore());

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop())
          context.pop();
        else
          context.go('/');
      },
      title: Text(locales.masail),
      body: OfflineDbPrompt(
        feature: 'masails',
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
                                .read(masailQueryParamsProvider.notifier)
                                .updateParams('authorId', '');
                          },
                          selectedItemProvider: qParams.containsKey('authorId')
                              ? singleMasailAuthorProvider(
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
                                queryProvider: masailQueryParamsProvider,
                                resourceFetcher:
                                    (Map<String, dynamic> params) async {
                                  final api =
                                      ref.read(masailApiServiceProvider);
                                  final offline =
                                      ref.read(masailOfflineServiceProvider);
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
                                    queryProvider: masailQueryParamsProvider,
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
                                  masailQueryParamsProvider.notifier,
                                )
                                .updateParams('categoryId', '');
                          },
                          selectedItemProvider:
                              qParams.containsKey('categoryId')
                                  ? singleMasailCategoryProvider(
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
                                queryProvider: masailQueryParamsProvider,
                                resourceFetcher: (
                                  Map<String, dynamic> params,
                                ) async {
                                  final api =
                                      ref.read(masailApiServiceProvider);
                                  final offline =
                                      ref.read(masailOfflineServiceProvider);
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
                                    queryProvider: masailQueryParamsProvider,
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
                          queryProvider: masailQueryParamsProvider,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: SearchButtonField(
                          value: qParams['search'],
                          onUpdate: (value) {
                            ref
                                .read(masailQueryParamsProvider.notifier)
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
                      .read(masailQueryParamsProvider.notifier)
                      .updateParams('hasAudio', '');
                },
                activateSecond: () {
                  ref
                      .read(masailQueryParamsProvider.notifier)
                      .updateParams('hasAudio', 'false');
                },
                activateThird: () {
                  ref
                      .read(masailQueryParamsProvider.notifier)
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
                  destination: scope.applyTo('/masail/${tabProgress.id}'),
                  icon: Icons.menu_book_outlined),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  controller: listState.controller,
                  scrollController: listState.scrollController,
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(masailApiServiceProvider);
                    final offline = ref.read(masailOfflineServiceProvider);
                    try {
                      return await api.fetchMasail(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        authorId: qParams['authorId'],
                        categoryId: qParams['categoryId'],
                        hasAudio: qParams['hasAudio'],
                        dateFrom: dateRange.from,
                        dateTo: dateRange.to,
                      );
                    } catch (_) {
                      return await offline.queryMasails(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 9,
                        search: qParams['search'],
                        authorId: qParams['authorId'],
                        categoryId: qParams['categoryId'],
                        hasAudio: qParams['hasAudio'] == 'true'
                            ? true
                            : (qParams['hasAudio'] == 'false' ? false : null),
                        dateFrom: dateRange.from,
                        dateTo: dateRange.to,
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastMasailId;
                    return InkWell(
                      onTap: () =>
                          context.push(scope.applyTo('/masail/${item.id}')),
                      child: ContentListCard(
                        recentlyVisited: isRecent,
                        highlightProvider: getDownloadedMasailByIdProvider(
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          settingsQuery.when(
            loading: () => const SizedBox.shrink(),
            error: (error, _) => const SizedBox.shrink(),
            data: (settings) {
              if (settings['ask-question'] == true) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: 170,
                    height: 40,
                    child: WithPreferences(
                      builder: (context, preferences) {
                        final colors =
                            Theme.of(context).extension<AppThemeColors>()!;

                        return FloatingActionButton.extended(
                          heroTag: 'ask-question',
                          onPressed: () => context.push('/masail/ask-question'),
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: colors.divider),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              Icons.question_mark,
                              size: 18,
                              color: colors.active,
                            ),
                          ),
                          label: Text(
                            locales.askQuestion,
                            style: textTheme.labelMedium?.copyWith(
                              color: colors.appBarText,
                            ),
                          ),
                          backgroundColor: colors.appBarBg,
                          foregroundColor: colors.appBarText,
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}

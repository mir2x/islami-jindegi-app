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
import 'package:native_app/widgets/presentation/content_list_card.dart';
import 'package:native_app/providers/downloaded_malfuzat.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import '../providers/malfuzat_providers.dart';

class MalfuzatListScreen extends ConsumerStatefulWidget {
  const MalfuzatListScreen({super.key});

  @override
  ConsumerState<MalfuzatListScreen> createState() => _MalfuzatListScreenState();
}

class _MalfuzatListScreenState extends ConsumerState<MalfuzatListScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  String? _lastScrolledToId;

  GlobalKey _keyFor(String id) => _itemKeys.putIfAbsent(id, () => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLastVisited(String? lastId) {
    if (lastId == null || lastId == _lastScrolledToId) return;
    final ctx = _keyFor(lastId).currentContext;
    if (ctx != null) {
      _lastScrolledToId = lastId;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        final retryCtx = _keyFor(lastId).currentContext;
        if (retryCtx != null) {
          _lastScrolledToId = lastId;
          Scrollable.ensureVisible(
            retryCtx,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: 0.3,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(malfuzatQueryParamsProvider);
    final lastVisited = ref.watch(lastVisitedProvider);
    final lastMalfuzatId = lastVisited.value?.getString('lastMalfuzat');

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
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
                                onClear: () {
                                  ref
                                      .read(
                                        malfuzatQueryParamsProvider.notifier,
                                      )
                                      .updateParams('malfuzatAuthorId', '');
                                },
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
                                    onClear: () {
                                      ref
                                          .read(
                                            malfuzatQueryParamsProvider
                                                .notifier,
                                          )
                                          .updateParams(
                                            'malfuzatCategoryId',
                                            '',
                                          );
                                      ref
                                          .read(
                                            malfuzatQueryParamsProvider
                                                .notifier,
                                          )
                                          .updateParams(
                                            'malfuzatSubcategoryId',
                                            '',
                                          );
                                    },
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
                                          searchEnabled: true,
                                          queryProvider:
                                              malfuzatQueryParamsProvider,
                                          resourceFetcher: (
                                            Map<String, dynamic> params,
                                          ) async {
                                            final api = ref.read(
                                              malfuzatApiServiceProvider,
                                            );
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
                  scrollController: _scrollController,
                  onFirstPageLoaded: () => _scrollToLastVisited(lastMalfuzatId),
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
                    final isRecent = item.id == lastMalfuzatId;
                    if (isRecent && _lastScrolledToId != item.id) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToLastVisited(item.id),
                      );
                    }
                    return InkWell(
                      key: _keyFor(item.id),
                      onTap: () => context.push('/malfuzat/${item.id}'),
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
                            LastVisited(
                              resourceKey: 'lastMalfuzat',
                              resourceId: item.id,
                              isAudio: item.audio != null,
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

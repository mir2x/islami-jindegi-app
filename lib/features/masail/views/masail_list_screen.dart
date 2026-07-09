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
import 'package:native_app/widgets/filter/triple_switch_button.dart';
import 'package:native_app/widgets/presentation/content_list_card.dart';
import 'package:native_app/providers/downloaded_masail.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/masail_providers.dart';

class MasailListScreen extends ConsumerStatefulWidget {
  const MasailListScreen({super.key});

  @override
  ConsumerState<MasailListScreen> createState() => _MasailListScreenState();
}

class _MasailListScreenState extends ConsumerState<MasailListScreen> {
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
    var qParams = ref.watch(masailQueryParamsProvider);
    var settingsQuery = ref.watch(masailSettingsProvider);
    final lastVisited = ref.watch(lastVisitedProvider);
    final lastMasailId = lastVisited.value?.getString('lastMasail');

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.masail),
      body: OfflineDbPrompt(
        feature: 'masails',
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
                                active: qParams.containsKey('authorId'),
                                onClear: () {
                                  ref
                                      .read(masailQueryParamsProvider.notifier)
                                      .updateParams('authorId', '');
                                },
                                selectedItemProvider:
                                    qParams.containsKey('authorId')
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
                                          paramKey: 'authorId',
                                          queryProvider:
                                              masailQueryParamsProvider,
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
                                        return await api.fetchCategories(
                                          page: params['page'] ?? 1,
                                          perPage: params['per_page'] ?? 16,
                                          search: params['search'],
                                        );
                                      },
                                      itemBuilder: (_, item, __) {
                                        return FilterItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'categoryId',
                                          queryProvider:
                                              masailQueryParamsProvider,
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
                        padding:
                            const EdgeInsets.only(top: 10, left: 15, right: 15),
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  scrollController: _scrollController,
                  onFirstPageLoaded: () => _scrollToLastVisited(lastMasailId),
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
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastMasailId;
                    if (isRecent && _lastScrolledToId != item.id) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToLastVisited(item.id),
                      );
                    }
                    return InkWell(
                      key: _keyFor(item.id),
                      onTap: () => context.push('/masail/${item.id}'),
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
                            LastVisited(
                              resourceKey: 'lastMasail',
                              resourceId: item.id,
                              isAudio: item.hasAudio == true,
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

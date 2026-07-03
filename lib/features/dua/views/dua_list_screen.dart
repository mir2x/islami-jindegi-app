import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/content_list_card.dart';
import 'package:native_app/providers/last_visited.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import '../providers/dua_providers.dart';

class DuaListScreen extends ConsumerStatefulWidget {
  const DuaListScreen({super.key});

  @override
  ConsumerState<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends ConsumerState<DuaListScreen> {
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
    var qParams = ref.watch(duaQueryParamsProvider);
    final lastVisited = ref.watch(lastVisitedProvider);
    final lastDuaId = lastVisited.value?.getString('lastDuaDurud');

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.duaDurud),
      body: OfflineDbPrompt(
        feature: 'duas',
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: FilterButton(
                label: locales.categories,
                active: qParams.containsKey('duaCategoryId'),
                onClear: () {
                  ref
                      .read(duaQueryParamsProvider.notifier)
                      .updateParams('duaCategoryId', '');
                },
                selectedItemProvider: qParams.containsKey('duaCategoryId')
                    ? singleDuaCategoryProvider(
                        qParams['duaCategoryId'],
                      )
                    : null,
                selectedItemLabel: (dynamic item) {
                  return item.title;
                },
                children: [
                  Expanded(
                    child: FilterList(
                      title: locales.categories,
                      paramKeys: const ['duaCategoryId'],
                      searchEnabled: true,
                      queryProvider: duaQueryParamsProvider,
                      resourceFetcher: (Map<String, dynamic> params) async {
                        final api = ref.read(duaApiServiceProvider);
                        final offline = ref.read(duaOfflineServiceProvider);
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
                          );
                        }
                      },
                      itemBuilder: (_, item, __) {
                        return FilterItem(
                          itemId: item.id,
                          itemTitle: item.title,
                          paramKey: 'duaCategoryId',
                          queryProvider: duaQueryParamsProvider,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: SearchButtonField(
                value: qParams['search'],
                onUpdate: (value) {
                  ref
                      .read(duaQueryParamsProvider.notifier)
                      .updateParams('search', value);
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  scrollController: _scrollController,
                  onFirstPageLoaded: () => _scrollToLastVisited(lastDuaId),
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(duaApiServiceProvider);
                    final offline = ref.read(duaOfflineServiceProvider);
                    try {
                      return await api.fetchDuas(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 20,
                        search: params['search'],
                        duaCategoryId: params['duaCategoryId'],
                      );
                    } catch (_) {
                      return await offline.queryDuas(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 20,
                        search: params['search'],
                        duaCategoryId: params['duaCategoryId'],
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastDuaId;
                    if (isRecent && _lastScrolledToId != item.id) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToLastVisited(item.id),
                      );
                    }
                    return InkWell(
                      key: _keyFor(item.id),
                      onTap: () => context.push('/duas/${item.id}'),
                      child: ContentListCard(
                        recentlyVisited: isRecent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                item.title,
                                style: textTheme.titleMedium?.copyWith(
                                  height: 1.25,
                                ),
                              ),
                            ),
                            LastVisited(
                              resourceKey: 'lastDuaDurud',
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
    );
  }
}

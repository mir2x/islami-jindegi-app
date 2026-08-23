import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/content_list_card.dart';
import 'package:native_app/widgets/presentation/continue_reading_card.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import '../providers/dua_providers.dart';
import '../providers/dua_progress_provider.dart';

class DuaListScreen extends ConsumerStatefulWidget {
  const DuaListScreen({super.key});

  @override
  ConsumerState<DuaListScreen> createState() => _DuaListScreenState();
}

class _DuaListScreenState extends ConsumerState<DuaListScreen> {
  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(duaQueryParamsProvider);
    final progress = ref.watch(duaProgressProvider);
    final lastDuaId = progress?.id;
    final listState = ref.watch(
      duaListStateProvider(
        RetainedListKey(Map.unmodifiable(Map<String, dynamic>.from(qParams))),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => listState.restore());

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop())
          context.pop();
        else
          context.go('/');
      },
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
                active: qParams.containsKey('categoryId'),
                onClear: () {
                  ref
                      .read(duaQueryParamsProvider.notifier)
                      .updateParams('categoryId', '');
                },
                selectedItemProvider: qParams.containsKey('categoryId')
                    ? singleDuaCategoryProvider(
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
                            search: params['search'],
                          );
                        }
                      },
                      itemBuilder: (_, item, __) {
                        return FilterItem(
                          itemId: item.id,
                          itemTitle: item.title,
                          paramKey: 'categoryId',
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
            if (progress != null)
              ContinueReadingCard(
                title: progress.title,
                destination: '/duas/${progress.id}',
                icon: Icons.menu_book_outlined,
              ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: InfiniteList(
                  qParams: qParams,
                  controller: listState.controller,
                  scrollController: listState.scrollController,
                  resourceFetcher: (Map<String, dynamic> params) async {
                    final api = ref.read(duaApiServiceProvider);
                    final offline = ref.read(duaOfflineServiceProvider);
                    try {
                      return await api.fetchDuas(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 20,
                        search: params['search'],
                        categoryId: params['categoryId'],
                      );
                    } catch (_) {
                      return await offline.queryDuas(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 20,
                        search: params['search'],
                        categoryId: params['categoryId'],
                      );
                    }
                  },
                  itemBuilder: (_, item, __) {
                    final isRecent = item.id == lastDuaId;
                    return InkWell(
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

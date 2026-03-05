import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/offline_db_prompt.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import '../providers/dua_providers.dart';

class DuaListScreen extends StatelessWidget {
  const DuaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WithPreferences(
      builder: (context, preferences) {
        return _OfflineDuaList(preferences: preferences);
      },
    );
  }
}

class _OfflineDuaList extends ConsumerStatefulWidget {
  const _OfflineDuaList({required this.preferences});

  final dynamic preferences;

  @override
  _OfflineDuaListState createState() => _OfflineDuaListState();
}

class _OfflineDuaListState extends ConsumerState<_OfflineDuaList> {
  ScrollController? duaController;

  void updateLastDuaPosition() {
    EasyDebounce.debounce(
      'dua-position',
      const Duration(milliseconds: 250),
      () {
        if (duaController!.hasClients) {
          widget.preferences.setDouble(
            'lastDuaPosition',
            duaController!.position.pixels,
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    double lastDuaPosition =
        widget.preferences.getDouble('lastDuaPosition') ?? 0.0;

    duaController = ScrollController(initialScrollOffset: lastDuaPosition);
    duaController!.addListener(updateLastDuaPosition);
  }

  @override
  void dispose() {
    duaController!.removeListener(updateLastDuaPosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(duaQueryParamsProvider);

    var modelQuery = ref.watch(allDuasProvider(qParams));

    return AppScaffold(
      title: Text(locales.duaDurud),
      body: OfflineDbPrompt(
        feature: 'duas',
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: FilterButton(
                      label: locales.categories,
                      active: qParams.containsKey('duaCategoryId'),
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
                            queryProvider: duaQueryParamsProvider,
                            resourceFetcher:
                                (Map<String, dynamic> params) async {
                              final api = ref.read(duaApiServiceProvider);
                              return await api.fetchCategories(
                                page: params['page'] ?? 1,
                                perPage: params['per_page'] ?? 16,
                              );
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
                  const SizedBox(width: 15),
                  Expanded(
                    child: SearchButtonField(
                      value: qParams['search'],
                      onUpdate: (value) {
                        ref
                            .read(duaQueryParamsProvider.notifier)
                            .updateParams('search', value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: modelQuery.when(
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  error: (error, _) => Text(error.toString()),
                  data: (resources) {
                    return ListView.builder(
                      controller: duaController,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      itemCount: resources.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = resources[index];

                        return InkWell(
                          onTap: () => context.push('/duas/${item.id}'),
                          child: ListItem(
                            item: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    item.title,
                                    style: textTheme.titleMedium,
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

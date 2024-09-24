import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';

class Duas extends StatelessWidget {
  const Duas({super.key});

  @override
  Widget build(BuildContext context) {
    return WithPreferences(
      builder: (context, preferences) {
        return OfflineDuas(preferences: preferences);
      },
    );
  }
}

class OfflineDuas extends ConsumerStatefulWidget {
  const OfflineDuas({
    super.key,
    required this.preferences,
  });

  final dynamic preferences;

  @override
  OfflineDuasState createState() => OfflineDuasState();
}

class OfflineDuasState extends ConsumerState<OfflineDuas> {
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
    var qParams = ref.watch(queryParamsProvider);

    AllModelsQuery query = AllModelsQuery(
      repository: ref.duas,
      params: {...qParams, 'published': true, 'offline': true},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return AppScaffold(
      title: Text(locales.duaDurud),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: FilterButton(
                    label: locales.categories,
                    active: qParams.keys.any(
                      (k) => k == 'duaCategoryId',
                    ),
                    children: [
                      Expanded(
                        child: FilterList(
                          title: locales.categories,
                          paramKeys: const ['duaCategoryId'],
                          queryBuilder: (Map<String, dynamic> params) {
                            return AllModelsQuery(
                              repository: ref.duaCategories,
                              params: {
                                ...params,
                                'offline': true,
                              },
                            );
                          },
                          itemBuilder: (_, item, __) {
                            return FilterItem(
                              itemId: item.id,
                              itemTitle: item.title,
                              paramKey: 'duaCategoryId',
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
                        onTap: () => QR.to('duas/${item.id}'),
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
    );
  }
}

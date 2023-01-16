import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/date.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/format_date.dart';

class Bayans extends ConsumerWidget {
  const Bayans({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    return MyScaffold(
      title: const Text('Bayans'),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: FilterButton(
                    active: qParams.keys.any(
                      (k) => ['bayanCategoryId', 'speakerId'].contains(k),
                    ),
                    children: [
                      Expanded(
                        child: FilterList(
                          title: 'Categories',
                          paramKeys: const ['bayanCategoryId'],
                          queryBuilder: (Map<String, dynamic> params) {
                            return AllModelsQuery(
                              repository: ref.bayanCategories,
                              params: params,
                            );
                          },
                          itemBuilder: (_, item, __) {
                            return FilterItem(
                              itemId: item.id,
                              itemTitle: item.title,
                              paramKey: 'bayanCategoryId',
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Expanded(
                        child: FilterList(
                          title: 'Speakers',
                          paramKeys: const ['speakerId'],
                          queryBuilder: (Map<String, dynamic> params) {
                            return AllModelsQuery(
                              repository: ref.speakers,
                              params: params,
                            );
                          },
                          itemBuilder: (_, item, __) {
                            return FilterItem(
                              itemId: item.id,
                              itemTitle: item.name,
                              paramKey: 'speakerId',
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
                  child: SearchField(
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
          Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
            child: DateFilter(),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InfiniteList(
                pageSize: 9,
                qParams: qParams,
                resourceFetcher: (Map<String, dynamic> params) async {
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.bayans,
                    params: {
                      ...params,
                      'include': 'speaker',
                    },
                  );

                  return await ref.read(allModelsProvider(query).future);
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('bayans/${item.id}'),
                    child: ListItem(
                      item: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.titleMedium,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              formatDate(item.publishedAt),
                              style: textTheme.labelSmall,
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
    );
  }
}

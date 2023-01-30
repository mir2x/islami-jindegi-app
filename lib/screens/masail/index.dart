import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/nested_item.dart';
import 'package:native_app/widgets/filter/subitem.dart';
import 'package:native_app/widgets/filter/triple_switch_button.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class Masail extends ConsumerWidget {
  const Masail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    return MyScaffold(
      title: const Text('Masail'),
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
                      (k) => ['masailCategoryId', 'masailSubcategoryId']
                          .contains(k),
                    ),
                    children: [
                      Expanded(
                        child: FilterList(
                          title: 'Categories',
                          paramKeys: const [
                            'masailCategoryId',
                            'masailSubcategoryId'
                          ],
                          queryBuilder: (Map<String, dynamic> params) {
                            return AllModelsQuery(
                              repository: ref.masailCategories,
                              params: {
                                ...params,
                                'include': 'masail-subcategories'
                              },
                            );
                          },
                          itemBuilder: (_, item, __) {
                            if (item.masailSubcategories.length > 0) {
                              return FilterNestedItem(
                                itemTitle: item.title,
                                paramKey: 'masailSubcategoryId',
                                subitems: item.masailSubcategories,
                                subitemBuilder: (var subitem) {
                                  return FilterSubitem(
                                    itemId: subitem.id,
                                    itemTitle: subitem.title,
                                    paramKey: 'masailSubcategoryId',
                                  );
                                },
                              );
                            } else {
                              return FilterItem(
                                itemId: item.id,
                                itemTitle: item.title,
                                paramKey: 'masailCategoryId',
                              );
                            }
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
            child: TripleSwitchButton(
              firstLabel: 'ALL',
              secondLabel: 'TEXT',
              thirdLabel: 'AUDIO',
              activateFirst: () {
                ref
                    .read(
                      queryParamsProvider.notifier,
                    )
                    .updateParams(
                      'hasAudio',
                      '',
                    );
              },
              activateSecond: () {
                ref
                    .read(
                      queryParamsProvider.notifier,
                    )
                    .updateParams(
                      'hasAudio',
                      'false',
                    );
              },
              activateThird: () {
                ref
                    .read(
                      queryParamsProvider.notifier,
                    )
                    .updateParams(
                      'hasAudio',
                      'true',
                    );
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
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.masails,
                    params: params,
                  );

                  return await ref.read(allModelsProvider(query).future);
                },
                itemBuilder: (_, item, __) {
                  return InkWell(
                    onTap: () => QR.to('masail/${item.id}'),
                    child: ListItem(
                      item: Text(
                        item.title,
                        style: textTheme.titleMedium,
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

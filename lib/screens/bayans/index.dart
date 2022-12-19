import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/widgets/presentation/filter_list_item.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/theme/colors.dart';

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
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          double screenWidth =
                              MediaQuery.of(context).size.width;
                          double screenHeight =
                              MediaQuery.of(context).size.height;

                          return Dialog(
                            backgroundColor: ThemeColors.color1,
                            child: Container(
                              width: screenWidth,
                              height: screenHeight * 0.8,
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 25,
                                left: 15,
                                right: 15,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text('Speakers'),
                                      if (qParams.containsKey('speakerId') &&
                                          qParams['speakerId'].isNotEmpty) ...[
                                        IconButton(
                                          onPressed: () {
                                            ref
                                                .read(
                                                  queryParamsProvider.notifier,
                                                )
                                                .updateParams('speakerId', '');
                                            Navigator.of(context).pop();
                                          },
                                          constraints: const BoxConstraints(
                                            maxHeight: 40,
                                          ),
                                          splashRadius: 24,
                                          icon: const Icon(
                                            Icons.close,
                                          ),
                                        )
                                      ] else
                                        ...[],
                                    ],
                                  ),
                                  Expanded(
                                    child: InfiniteList(
                                      pageSize: 8,
                                      padding: 5,
                                      resourceFetcher:
                                          (Map<String, dynamic> params) async {
                                        AllModelsQuery query = AllModelsQuery(
                                          repository: 'speakers',
                                          params: params,
                                        );

                                        return await ref.read(
                                          allModelsProvider(query).future,
                                        );
                                      },
                                      itemBuilder: (_, item, __) {
                                        return InkWell(
                                          onTap: () {
                                            ref
                                                .read(
                                                  queryParamsProvider.notifier,
                                                )
                                                .updateParams(
                                                  'speakerId',
                                                  item.id,
                                                );
                                            Navigator.of(context).pop();
                                          },
                                          child: FilterListItem(
                                            item: Text(
                                              item.name,
                                              style: textTheme.titleMedium,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: ThemeColors.color3),
                      minimumSize: const Size.fromHeight(45),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter', style: textTheme.labelMedium),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InfiniteList(
                pageSize: 9,
                qParams: qParams,
                resourceFetcher: (Map<String, dynamic> params) async {
                  AllModelsQuery query = AllModelsQuery(
                    repository: 'bayans',
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

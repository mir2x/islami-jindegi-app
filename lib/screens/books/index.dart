import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/widgets/filter/button.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/filter/nested_item.dart';
import 'package:native_app/widgets/filter/subitem.dart';
import 'package:native_app/providers/check_asset_file.dart';
import 'package:native_app/widgets/responsive/image.dart';
import 'package:native_app/settings/image.dart';

class Books extends ConsumerWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);
    // MediaQuery.of(context) refreshes the screen when search input is focused.
    double screenWidth =
        View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
    bool isMobile = screenWidth < 768;

    return AppScaffold(
      title: Text(locales.books),
      body: Column(
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
                              label: locales.authors,
                              active: qParams.containsKey('authorId'),
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.authors,
                                    paramKeys: const ['authorId'],
                                    pageSize: 16,
                                    searchEnabled: true,
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.authors,
                                        params: params,
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      return FilterItem(
                                        itemId: item.id,
                                        itemTitle: item.name,
                                        paramKey: 'authorId',
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
                            child: FilterButton(
                              label: locales.categories,
                              active: qParams.keys.any(
                                (k) => [
                                  'bookCategoryId',
                                  'bookSubcategoryId',
                                ].contains(k),
                              ),
                              children: [
                                Expanded(
                                  child: FilterList(
                                    title: locales.categories,
                                    paramKeys: const [
                                      'bookCategoryId',
                                      'bookSubcategoryId',
                                    ],
                                    pageSize: 16,
                                    queryBuilder:
                                        (Map<String, dynamic> params) {
                                      return AllModelsQuery(
                                        repository: ref.bookCategories,
                                        params: {
                                          ...params,
                                          'include': 'book-subcategories',
                                        },
                                      );
                                    },
                                    itemBuilder: (_, item, __) {
                                      if (item.bookSubcategories.length > 0) {
                                        return FilterNestedItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'bookSubcategoryId',
                                          subitems: item.bookSubcategories,
                                          subitemBuilder: (var subitem) {
                                            return FilterSubitem(
                                              itemId: subitem.id,
                                              itemTitle: subitem.title,
                                              paramKey: 'bookSubcategoryId',
                                            );
                                          },
                                        );
                                      } else {
                                        return FilterItem(
                                          itemId: item.id,
                                          itemTitle: item.title,
                                          paramKey: 'bookCategoryId',
                                        );
                                      }
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
                              .read(queryParamsProvider.notifier)
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InfiniteList(
                qParams: qParams,
                resourceFetcher: (Map<String, dynamic> params) async {
                  AllModelsQuery query = AllModelsQuery(
                    repository: ref.books,
                    params: {
                      ...params,
                      'published': true,
                      'include': 'authors',
                    },
                  );

                  return await ref.watch(allModelsProvider(query).future);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 2 : 3,
                  crossAxisSpacing: isMobile ? 15 : 20,
                  mainAxisExtent: isMobile ? 300 : 360,
                ),
                itemBuilder: (_, item, __) {
                  var assetChecker = ref.watch(
                    checkAssetFileProvider('images/books/${item.id}.jpg'),
                  );

                  Map<String, int> dimensions = imageSettings['book']['image'];

                  return InkWell(
                    onTap: () => QR.to('books/${item.id}'),
                    child: Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: assetChecker.when(
                            loading: () => AspectRatio(
                              aspectRatio:
                                  dimensions['width']! / dimensions['height']!,
                              child: const SizedBox.shrink(),
                            ),
                            error: (error, _) => const SizedBox.shrink(),
                            data: (exists) {
                              if (exists) {
                                return AspectRatio(
                                  aspectRatio: dimensions['width']! /
                                      dimensions['height']!,
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/books/${item.id}.jpg',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                );
                              } else {
                                return ResponsiveImage(
                                  image: item.image,
                                  model: 'book',
                                  vwset: const {'xs': 50},
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            item.title,
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            item.authors.first.name,
                            textAlign: TextAlign.center,
                            style: textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 200,
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () => QR.to('books/downloads'),
          icon: const Icon(Icons.download),
          label: Text(
            '${locales.downloaded} ${locales.books}',
            style: textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}

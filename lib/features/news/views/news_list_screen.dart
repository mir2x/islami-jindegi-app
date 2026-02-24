import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/format_date.dart';
import 'package:native_app/widgets/utils/last_visited.dart';
import '../providers/news_providers.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(newsQueryParamsProvider);

    return AppScaffold(
      title: Text(locales.news),
      body: WithConnectivity(
        builder: (context, isConnected) {
          if (isConnected) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: SearchButtonField(
                    value: qParams['search'],
                    onUpdate: (value) {
                      ref
                          .read(newsQueryParamsProvider.notifier)
                          .updateParams('search', value);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InfiniteList(
                      qParams: qParams,
                      resourceFetcher: (Map<String, dynamic> params) async {
                        final api = ref.read(newsApiServiceProvider);
                        return await api.fetchNews(
                          page: params['page'] ?? 1,
                          perPage: params['per_page'] ?? 9,
                          search: qParams['search'],
                        );
                      },
                      itemBuilder: (_, item, __) {
                        return InkWell(
                          onTap: () => QR.to('news/${item.id}'),
                          child: ListItem(
                            item: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: textTheme.titleMedium,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          formatDate(
                                            item.publishedAt,
                                            currentLang,
                                          ),
                                          style: textTheme.labelSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                LastVisited(
                                  resourceKey: 'lastNews',
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
            );
          } else {
            return Center(
              child: Text(
                locales.connectToInternetMsg,
                style: textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

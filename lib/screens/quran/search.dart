import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';

class QuranSearch extends ConsumerWidget {
  const QuranSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    return AppScaffold(
      title: Text(locales.searchInQuran),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                SearchField(
                  value: qParams['search'],
                  labelText: locales.searchInArabic,
                  reverse: true,
                  onUpdate: (value) {
                    ref
                        .read(queryParamsProvider.notifier)
                        .updateParams('search', value);
                  },
                ),
                if (qParams.containsKey('search') &&
                    qParams['search'].length > 100) ...[
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      locales.quranSearchErrorMessage,
                      style: textTheme.labelSmall,
                    ),
                  )
                ]
              ],
            ),
          ),
          if (qParams.containsKey('search') &&
              qParams['search'].length > 2 &&
              qParams['search'].length <= 100) ...[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 30,
                ),
                child: InfiniteList(
                  qParams: qParams,
                  pageSize: 10,
                  resourceFetcher: (Map<String, dynamic> params) async {
                    AllModelsQuery query = AllModelsQuery(
                      repository: ref.ayahs,
                      params: {...params, 'include': 'surah'},
                    );

                    return await ref.read(allModelsProvider(query).future);
                  },
                  itemBuilder: (_, ayah, __) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${locales.surah}:'),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () =>
                                    QR.to('quran/surah/${ayah.surah.value.id}'),
                                child: Text(
                                  ayah.surah.value.title,
                                  style: textTheme.titleMedium,
                                ),
                              ),
                              Text(', ${locales.ayah}: ${ayah.surahPosition}')
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              ayah.title,
                              textDirection: TextDirection.rtl,
                              style: textTheme.headlineMedium,
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
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/helpers/contextual_translation.dart';

class QuranSearch extends ConsumerWidget {
  const QuranSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
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
                SearchButtonField(
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
                                  contextualTranslation(
                                    locale: currentLang,
                                    enText: ayah.surah.value.title,
                                    bnText: ayah.surah.value.titleBn,
                                  ),
                                  style: textTheme.titleMedium,
                                ),
                              ),
                              Text(
                                ', ${locales.ayah}: ${numFormatter.format(ayah.surahPosition)}',
                              )
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

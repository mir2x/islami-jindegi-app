import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/query_params.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/inputs/search_button_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/theme/app_theme.dart';

class QuranSearch extends ConsumerStatefulWidget {
  const QuranSearch({super.key});

  @override
  QuranSearchState createState() => QuranSearchState();
}

class QuranSearchState extends ConsumerState<QuranSearch> {
  String language = 'Arabic';

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    var qParams = ref.watch(queryParamsProvider);

    bool searchTooLong = (qParams.containsKey('ayahSearch') &&
            qParams['ayahSearch'].length > 100) ||
        (qParams.containsKey('translationSearch') &&
            qParams['translationSearch'].length > 100);

    bool validAyahSearch = qParams.containsKey('ayahSearch') &&
        qParams['ayahSearch'].length > 2 &&
        qParams['ayahSearch'].length <= 100;

    bool validTranslationSearch = qParams.containsKey('translationSearch') &&
        qParams['translationSearch'].length > 2 &&
        qParams['translationSearch'].length <= 100;

    bool validSearch = validAyahSearch || validTranslationSearch;

    return AppScaffold(
      showPattern: false,
      title: Text(locales.searchInQuran),
      body: Column(
        children: [
          const SizedBox(height: 20),
          WithPreferences(
            builder: (context, preferences) {
              String theme = preferences.getString('theme') ?? 'classic';

              return AnimatedToggleSwitch<String>.size(
                current: language,
                values: const ['Arabic', 'Bangla'],
                spacing: 10,
                style: const ToggleStyle(
                  borderColor: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                ),
                borderWidth: 5,
                height: 42,
                selectedIconScale: 1.0,
                onChanged: (b) {
                  setState(() {
                    language = b;

                    var paramsNotifier = ref.read(queryParamsProvider.notifier);
                    paramsNotifier.updateParams('ayahSearch', '');
                    paramsNotifier.updateParams('translationSearch', '');
                  });
                },
                indicatorSize: const Size.fromWidth(80),
                styleBuilder: (b) => ToggleStyle(
                  backgroundColor: AppTheme.backgroundColor[theme],
                  indicatorColor: AppTheme.indicatorColor[theme],
                ),
                customIconBuilder: (context, local, global) {
                  final text = [locales.arabic, locales.bangla][local.index];
                  return Center(
                    child: Text(
                      text,
                      style: textTheme.labelMedium,
                    ),
                  );
                },
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                if (language == 'Arabic') ...[
                  SearchButtonField(
                    key: const Key('ayah-search'),
                    value: qParams['ayahSearch'],
                    labelText: locales.searchInArabic,
                    reverse: true,
                    onUpdate: (value) {
                      ref
                          .read(queryParamsProvider.notifier)
                          .updateParams('ayahSearch', value);
                    },
                  ),
                ] else if (language == 'Bangla') ...[
                  SearchButtonField(
                    key: const Key('translation-search'),
                    value: qParams['translationSearch'],
                    labelText: locales.searchInBangla,
                    onUpdate: (value) {
                      ref
                          .read(queryParamsProvider.notifier)
                          .updateParams('translationSearch', value);
                    },
                  ),
                ],
                if (searchTooLong) ...[
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      locales.quranSearchErrorMessage,
                      style: textTheme.labelSmall,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (validSearch) ...[
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
                      params: {
                        ...params,
                        'include': 'surah,ayah-translations',
                        'offline': true,
                      },
                    );

                    return await ref.watch(allModelsProvider(query).future);
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
                                onTap: () => QR
                                    .to('quran/surah/${ayah.surah.value.slug}'),
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
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              ayah.title,
                              textDirection: TextDirection.rtl,
                              style: textTheme.labelLarge?.copyWith(
                                fontSize: 27,
                                height: 1.6,
                              ),
                            ),
                          ),
                          HtmlText(text: ayah.ayahTranslations.first.body),
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

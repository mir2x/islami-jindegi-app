import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/theme/colors.dart';
import 'bismillah.dart';
import 'ayah.dart';

class AyahList extends ConsumerWidget {
  const AyahList({
    super.key,
    required this.chapter,
    required this.filterParams,
  });

  final dynamic chapter;
  final Map filterParams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    var arabicFontSizeRatio = FontSizeRatio();
    var banglaFontSizeRatio = FontSizeRatio();
    var prefs = ref.watch(preferencesProvider);
    var qSettings = ref.watch(quranSettingsProvider);

    return AppScaffold(
      title: Text(
        contextualTranslation(
          locale: currentLang,
          enText: chapter.title,
          bnText: chapter.titleBn,
        ),
      ),
      body: prefs.when(
        loading: () => const SizedBox.shrink(),
        error: (error, _) => Text(error.toString()),
        data: (preferences) {
          var query = AllModelsQuery(
            repository: ref.ayahs,
            params: {
              ...filterParams,
              'quantity': chapter.totalAyat,
              'offline': true,
              if (qSettings.containsKey('translation') &&
                  qSettings['translation']) ...{'include': 'ayah-translations'},
            },
          );

          var modelQuery = ref.watch(allModelsProvider(query));

          return modelQuery.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, _) => Text(error.toString()),
            data: (resources) {
              if (qSettings.containsKey('tilawat') && qSettings['tilawat']) {
                String ayahs = resources.map((a) => a.title).join(' ');

                return ValueListenableBuilder<double>(
                  valueListenable: arabicFontSizeRatio,
                  builder: (context, ratio, child) {
                    return ItemContent(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
                            textDirection: TextDirection.rtl,
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 20 * ratio,
                            ),
                          ),
                        ),
                        Text(
                          ayahs,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.justify,
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: 20 * ratio,
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Column(
                  children: [
                    InkWell(
                      onTap: () => QR.to('quran/bismillah-tafseer'),
                      child: Bismillah(
                        chapter: chapter,
                        preferences: preferences,
                        arabicFontSizeRatio: arabicFontSizeRatio,
                        banglaFontSizeRatio: banglaFontSizeRatio,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: resources.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Ayah(
                            ayah: resources[index],
                            chapter: chapter,
                            preferences: preferences,
                            arabicFontSizeRatio: arabicFontSizeRatio,
                            banglaFontSizeRatio: banglaFontSizeRatio,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
      bottomBar: BottomBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: isSmallMobile ? 0 : 2),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (qSettings.containsKey('tilawat') &&
                          qSettings['tilawat']) ...[
                        const Icon(
                          Icons.check_box,
                          color: ThemeColors.color4,
                          size: 20,
                        ),
                      ] else ...[
                        const Icon(
                          Icons.check_box_outline_blank,
                          color: ThemeColors.color4,
                          size: 20,
                        ),
                      ],
                      Container(
                        margin: const EdgeInsets.only(left: 2, bottom: 1),
                        child: Text(
                          locales.tilawat,
                          style: isSmallMobile
                              ? textTheme.labelSmall
                              : textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    bool selectedTranslationOption =
                        qSettings.containsKey('tilawat')
                            ? qSettings['tilawat']
                            : false;

                    ref.read(quranSettingsProvider.notifier).updateSettings(
                          'tilawat',
                          !selectedTranslationOption,
                        );
                  },
                ),
              ),
              if (!(qSettings.containsKey('tilawat') &&
                  qSettings['tilawat'])) ...[
                Container(
                  margin: const EdgeInsets.only(left: 2),
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (qSettings.containsKey('translation') &&
                            qSettings['translation']) ...[
                          const Icon(
                            Icons.check_box,
                            color: ThemeColors.color4,
                            size: 20,
                          ),
                        ] else ...[
                          const Icon(
                            Icons.check_box_outline_blank,
                            color: ThemeColors.color4,
                            size: 20,
                          ),
                        ],
                        Container(
                          margin: const EdgeInsets.only(left: 2, bottom: 1),
                          child: Text(
                            locales.translation,
                            style: isSmallMobile
                                ? textTheme.labelSmall
                                : textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      bool selectedTranslationOption =
                          qSettings.containsKey('translation')
                              ? qSettings['translation']
                              : false;

                      ref.read(quranSettingsProvider.notifier).updateSettings(
                            'translation',
                            !selectedTranslationOption,
                          );
                    },
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              TextButton(
                child: Text(locales.font, style: textTheme.titleMedium),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: FontResizer(
                                  fontSizeRatio: arabicFontSizeRatio,
                                  text: locales.arabicFont,
                                ),
                              ),
                              FontResizer(
                                fontSizeRatio: banglaFontSizeRatio,
                                text: locales.banglaFont,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(right: isSmallMobile ? 0 : 2),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => QR.to('quran/settings'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

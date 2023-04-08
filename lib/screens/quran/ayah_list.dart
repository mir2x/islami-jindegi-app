import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/theme/colors.dart';
import 'bismillah.dart';
import 'bismillah_tafseer.dart';
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
    var fontSizeRatio = FontSizeRatio();
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
      body: Stack(
        children: [
          prefs.when(
            loading: () => const SizedBox.shrink(),
            error: (error, _) => Text(error.toString()),
            data: (preferences) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: const BismillahTafseer(),
                            ),
                          );
                        },
                      );
                    },
                    child: Bismillah(
                      chapter: chapter,
                      preferences: preferences,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 30,
                      ),
                      child: InfiniteList(
                        resourceFetcher: (Map<String, dynamic> params) async {
                          AllModelsQuery query = AllModelsQuery(
                            repository: ref.ayahs,
                            params: {
                              ...params,
                              ...filterParams,
                              if (qSettings.containsKey('translation') &&
                                  qSettings['translation']) ...{
                                'include': 'ayah-translations'
                              }
                            },
                          );

                          return await ref
                              .read(allModelsProvider(query).future);
                        },
                        itemBuilder: (_, ayah, __) {
                          return Ayah(
                            ayah: ayah,
                            chapter: chapter,
                            preferences: preferences,
                            fontSizeRatio: fontSizeRatio,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      bottomBar: BottomBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
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
                  margin: const EdgeInsets.only(left: 4, bottom: 1),
                  child: Text(
                    locales.translation,
                    style: textTheme.labelMedium,
                  ),
                )
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
          FontResizer(fontSizeRatio: fontSizeRatio),
          TextButton(
            child: Text(
              locales.settings,
              style: textTheme.titleMedium,
            ),
            onPressed: () => QR.to('quran/settings'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/filter/switch_button.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/utils/with_connectivity.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/with_last_visited.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';

class Quran extends ConsumerStatefulWidget {
  const Quran({super.key});

  @override
  QuranState createState() => QuranState();
}

class QuranState extends ConsumerState<Quran> {
  bool isSurahSelected = true;

  void loadSurah() {
    setState(() {
      isSurahSelected = true;
    });
  }

  void loadPara() {
    setState(() {
      isSurahSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;

    AllModelsQuery query;

    if (isSurahSelected) {
      query = AllModelsQuery(
        repository: ref.surahs,
        params: const {'quantity': 114, 'offline': true},
      );
    } else {
      query = AllModelsQuery(
        repository: ref.paras,
        params: const {'quantity': 30, 'offline': true},
      );
    }

    var modelQuery = ref.watch(allModelsProvider(query));

    return AppScaffold(
      title: Text(locales.quran),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: SwitchButton(
              firstLabel: locales.surah,
              secondLabel: locales.para,
              activateFirst: loadSurah,
              activateSecond: loadPara,
              isFirstActive: isSurahSelected,
              isSecondActive: !isSurahSelected,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: modelQuery.when(
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                error: (error, _) => Text(error.toString()),
                data: (resources) {
                  if (isSurahSelected) {
                    return ListView.builder(
                      key: const PageStorageKey<String>('surah'),
                      itemCount: resources.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = resources[index];

                        String? location;

                        if (item.location == 'Makkah') {
                          location = locales.makkah;
                        } else if (item.location == 'Madinah') {
                          location = locales.madinah;
                        } else if (item.location == 'Makkah & Madinah') {
                          location = locales.makkahAndMadinah;
                        }

                        return InkWell(
                          onTap: () => QR.to('quran/surah/${item.slug}'),
                          child: ListItem(
                            item: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${numFormatter.format(item.position)}.',
                                      style: textTheme.titleMedium,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      contextualTranslation(
                                        locale: currentLang,
                                        enText: item.title,
                                        bnText: item.titleBn,
                                      ),
                                      style: textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    WithLastVisited(
                                      builder: (context, settings) {
                                        if (settings.getString('lastSurah') ==
                                            item.id) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/icons/open-book.svg',
                                              fit: BoxFit.scaleDown,
                                              width: 25,
                                              height: 20,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),
                                    Text(
                                      '${locales.ayah}: ${numFormatter.format(item.totalAyat)}',
                                      style: textTheme.labelSmall,
                                    ),
                                    if (location != null) ...[
                                      Text(
                                        ', $location',
                                        style: textTheme.labelSmall,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      key: const PageStorageKey<String>('para'),
                      itemCount: resources.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = resources[index];

                        return InkWell(
                          onTap: () => QR.to('quran/para/${item.slug}'),
                          child: ListItem(
                            item: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  contextualTranslation(
                                    locale: currentLang,
                                    enText: item.title,
                                    bnText: item.titleBn,
                                  ),
                                  style: textTheme.titleMedium,
                                ),
                                Row(
                                  children: [
                                    WithLastVisited(
                                      builder: (context, settings) {
                                        if (settings.getString('lastPara') ==
                                            item.id) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/icons/open-book.svg',
                                              fit: BoxFit.scaleDown,
                                              width: 25,
                                              height: 20,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),
                                    Text(
                                      '${locales.ayah}: ${numFormatter.format(item.totalAyat)}',
                                      style: textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomBar: BottomBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          WithConnectivity(
            builder: (context, isConnected) {
              if (isConnected) {
                return TextButton(
                  child: Text(locales.search, style: textTheme.labelMedium),
                  onPressed: () => QR.to('quran/search'),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: TextButton(
              child: Text(locales.savedAyahs, style: textTheme.labelMedium),
              onPressed: () => QR.to('quran/bookmarks'),
            ),
          ),
        ],
      ),
    );
  }
}

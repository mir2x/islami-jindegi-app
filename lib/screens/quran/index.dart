import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/filter/switch_button.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/objects/all_models_query.dart';
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
    var connectivity = ref.watch(connectivityResultProvider);

    return AppScaffold(
      title: Text(locales.quran),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
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
              child: isSurahSelected
                  ? InfiniteList(
                      resourceFetcher: (Map<String, dynamic> params) async {
                        AllModelsQuery query = AllModelsQuery(
                          repository: ref.surahs,
                          params: params,
                        );

                        return await ref.read(allModelsProvider(query).future);
                      },
                      itemBuilder: (_, item, __) {
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
                    )
                  : InfiniteList(
                      resourceFetcher: (Map<String, dynamic> params) async {
                        AllModelsQuery query = AllModelsQuery(
                          repository: ref.paras,
                          params: params,
                        );

                        return await ref.read(allModelsProvider(query).future);
                      },
                      itemBuilder: (_, item, __) {
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
                                Text(
                                  '${locales.ayah}: ${numFormatter.format(item.totalAyat)}',
                                  style: textTheme.labelSmall,
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
      bottomBar: BottomBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 3),
            child: TextButton(
              child: Text(
                locales.pageBasedQuran,
                style: textTheme.titleMedium,
              ),
              onPressed: () => QR.to('quran/books'),
            ),
          ),
          connectivity.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text(error.toString()),
            data: (connectivityResult) {
              if (connectivityResult != ConnectivityResult.none) {
                return TextButton(
                  child: Text(
                    locales.search,
                    style: textTheme.titleMedium,
                  ),
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
              child: Text(
                locales.savedAyahs,
                style: textTheme.titleMedium,
              ),
              onPressed: () => QR.to('quran/bookmarks'),
            ),
          ),
        ],
      ),
    );
  }
}

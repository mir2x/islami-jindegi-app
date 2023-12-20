import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/widgets/presentation/bottom_bar.dart';
import 'package:native_app/widgets/buttons/font_resizer.dart';
import 'package:native_app/widgets/filter/list.dart';
import 'package:native_app/widgets/filter/item.dart';
import 'package:native_app/widgets/presentation/section_title.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallMobile = screenWidth < 340;
    var qSettings = ref.watch(quranSettingsProvider);

    return WithPreferences(
      builder: (context, preferences) {
        var arabicFontSizeRatio =
            FontSizeRatio(value: preferences.getDouble('ayahFontRatio'));
        var banglaFontSizeRatio =
            FontSizeRatio(value: preferences.getDouble('translationFontRatio'));

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

        return AppScaffold(
          showPattern: false,
          title: Text(
            contextualTranslation(
              locale: currentLang,
              enText: chapter.title,
              bnText: chapter.titleBn,
            ),
          ),
          body: modelQuery.when(
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
                              fontSize: 28 * ratio,
                              height: 1.5,
                            ),
                          ),
                        ),
                        Text(
                          ayahs,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.justify,
                          style: textTheme.labelLarge?.copyWith(
                            fontSize: 28 * ratio,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                final itemScrollController = ItemScrollController();
                final scrollOffsetController = ScrollOffsetController();
                final itemPositionsListener = ItemPositionsListener.create();
                final scrollOffsetListener = ScrollOffsetListener.create();

                List<int> marks = [];

                if (resources.length > 30) {
                  int jump = ((resources.length - 1) / 10).floor();

                  for (var i = 1; i < resources.length; i = i + jump) {
                    marks.add(i);
                  }
                }

                double screenHeight = MediaQuery.of(context).size.height;
                double markHeight = (screenHeight - 160) / 11;
                double offset = markHeight / 2 - 15;
                return Stack(
                  children: [
                    Column(
                      children: [
                        Bismillah(
                          chapter: chapter,
                          preferences: preferences,
                          arabicFontSizeRatio: arabicFontSizeRatio,
                          banglaFontSizeRatio: banglaFontSizeRatio,
                        ),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            key: PageStorageKey<String>(chapter.id),
                            itemScrollController: itemScrollController,
                            scrollOffsetController: scrollOffsetController,
                            itemPositionsListener: itemPositionsListener,
                            scrollOffsetListener: scrollOffsetListener,
                            itemCount: resources.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Ayah(
                                ayah: resources[index],
                                chapter: chapter,
                                preferences: preferences,
                                arabicFontSizeRatio: arabicFontSizeRatio,
                                banglaFontSizeRatio: banglaFontSizeRatio,
                                markAdjustment: marks.isNotEmpty ? 12 : 0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(marks.length, (index) {
                      return Positioned(
                        top: offset + markHeight * index,
                        left: 0,
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 6,
                            ),
                            child: Text(
                              marks[index].toString(),
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                          onTap: () {
                            itemScrollController.jumpTo(
                              index: marks[index] - 1,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                );
              }
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

                        ref.read(quranSettingsProvider.notifier).updateParams(
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

                          ref.read(quranSettingsProvider.notifier).updateParams(
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
                  if (!(qSettings.containsKey('tilawat') &&
                      qSettings['tilawat'])) ...[
                    TextButton(
                      child: Text(locales.qaris, style: textTheme.titleMedium),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                width: screenWidth,
                                height: screenHeight * 0.4,
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 25,
                                  left: 15,
                                  right: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: FilterList(
                                        title: locales.qaris,
                                        paramKeys: const ['qari'],
                                        queryProvider: quranSettingsProvider,
                                        queryBuilder:
                                            (Map<String, dynamic> params) {
                                          return AllModelsQuery(
                                            repository: ref.qaris,
                                            params: params,
                                          );
                                        },
                                        itemBuilder: (_, item, __) {
                                          return FilterItem(
                                            itemId: item.slug,
                                            itemTitle: item.name,
                                            paramKey: 'qari',
                                            queryProvider:
                                                quranSettingsProvider,
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
                    ),
                  ],
                  TextButton(
                    child: Text(locales.font, style: textTheme.titleMedium),
                    onPressed: () {
                      const List<Map<String, String>> arabicFonts = [
                        {
                          'label': 'Al Qalam Quran Majeed',
                          'value': 'arabic/al-qalam-quran-majeed',
                        },
                        {
                          'label': 'Al Qalam Kolkatta Quran Majeed',
                          'value': 'arabic/al-qalam-kolkatta',
                        },
                        {
                          'label': 'Al Mushaf Quran',
                          'value': 'arabic/al-mushaf',
                        },
                        {
                          'label': 'Al Qalam Quran',
                          'value': 'arabic/al-qalam-quran',
                        }
                      ];

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String theme =
                              preferences.getString('theme') ?? 'dark';

                          String selectedArabicFont = arabicFonts
                                  .map((i) => i['value'])
                                  .firstWhereOrNull((i) {
                                return i == preferences.getString('arabicFont');
                              }) ??
                              'arabic/al-mushaf';

                          return Dialog(
                            child: Container(
                              width: screenWidth,
                              height: 270,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: theme == 'dark'
                                      ? const AssetImage(
                                          'assets/images/icons/background-pattern-dark.png',
                                        )
                                      : const AssetImage(
                                          'assets/images/icons/background-pattern-light.png',
                                        ),
                                  repeat: ImageRepeat.repeat,
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 25,
                                left: 15,
                                right: 15,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 40),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SectionTitle(
                                          title: locales.arabicFont,
                                        ),
                                        Dropdown(
                                          items: arabicFonts,
                                          selectedValue: selectedArabicFont,
                                          updateItem: (value) {
                                            ref
                                                .read(
                                                  preferencesProvider.notifier,
                                                )
                                                .updateArabicFont(value);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Center(
                                        child: FontResizer(
                                          fontSizeRatio: arabicFontSizeRatio,
                                          text: locales.arabicFont,
                                          storeKey: 'ayahFontRatio',
                                        ),
                                      ),
                                      FontResizer(
                                        fontSizeRatio: banglaFontSizeRatio,
                                        text: locales.banglaFont,
                                        storeKey: 'translationFontRatio',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

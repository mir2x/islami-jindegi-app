import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/theme/app_theme.dart';
import 'package:native_app/theme/colors.dart';

class QuranBookSurahs extends ConsumerWidget {
  const QuranBookSurahs({
    super.key,
    required this.book,
    required this.pdfController,
    required this.closeDrawer,
  });

  final dynamic book;
  final PdfViewerController pdfController;
  final Function closeDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var query = AllModelsQuery(
      repository: ref.surahs,
      params: const {'quantity': 114, 'offline': true},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return Container(
      child: modelQuery.when(
        loading: () {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: const CircularProgressIndicator(),
            ),
          );
        },
        error: (error, _) => Text(error.toString()),
        data: (resources) {
          return StatefulSurahs(
            book: book,
            surahs: resources,
            pdfController: pdfController,
            closeDrawer: closeDrawer,
          );
        },
      ),
    );
  }
}

class StatefulSurahs extends ConsumerStatefulWidget {
  const StatefulSurahs({
    super.key,
    required this.book,
    required this.surahs,
    required this.pdfController,
    required this.closeDrawer,
  });

  final dynamic book;
  final List surahs;
  final PdfViewerController pdfController;
  final Function closeDrawer;

  @override
  ConsumerState<StatefulSurahs> createState() => _SurahsState();
}

class _SurahsState extends ConsumerState<StatefulSurahs> {
  dynamic selectedSurah;

  @override
  void initState() {
    super.initState();

    selectedSurah = widget.surahs.first;
  }

  updateSelectedSurah(surah) {
    setState(() {
      selectedSurah = surah;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'classic';

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        locales.ayah,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppTheme.labelContrastColor[theme],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: ThemeColors.color7,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: widget.surahs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = widget.surahs[index];

                            String surahTitle = contextualTranslation(
                              locale: currentLang,
                              enText: item.title,
                              bnText: item.titleBn,
                            );

                            return GestureDetector(
                              onTap: () => updateSelectedSurah(item),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedSurah.id == item.id
                                      ? AppTheme.activeItemColor[theme]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${numFormatter.format(item.position)}.',
                                      style: textTheme.titleMedium?.copyWith(
                                        color:
                                            AppTheme.titleContrastColor[theme],
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      surahTitle,
                                      style: textTheme.titleMedium?.copyWith(
                                        color:
                                            AppTheme.titleContrastColor[theme],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: selectedSurah.totalAyat,
                        itemBuilder: (BuildContext context, int index) {
                          var number = index + 1;

                          return InkWell(
                            onTap: () async {
                              var query = AllModelsQuery(
                                repository: ref.quranBookPages,
                                params: {
                                  'quranBookId': widget.book.id,
                                  'surahId': selectedSurah.id,
                                  'ayahNo': number,
                                  'quantity': 1,
                                  'offline': true,
                                },
                              );

                              var resources = await ref
                                  .watch(allModelsProvider(query).future);

                              if (resources.isNotEmpty) {
                                var bookPage = resources.first;
                                widget.pdfController.goToPage(
                                  pageNumber: bookPage.position,
                                );
                              }

                              widget.closeDrawer();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ThemeColors.color7,
                                  width: 0.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 10,
                              ),
                              child: Text(
                                numFormatter.format(number),
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppTheme.titleContrastColor[theme],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

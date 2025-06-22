import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:pdfrx/pdfrx.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/ayah_bookmarks.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/providers/first_model.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/theme/app_theme.dart';

class QuranBookBookmarks extends ConsumerWidget {
  const QuranBookBookmarks({
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
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;

    var ayahBookmarks = ref.watch(ayahBookmarksProvider);

    return Container(
      child: ayahBookmarks.when(
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
          return WithPreferences(
            builder: (context, preferences) {
              String theme = preferences.getString('theme') ?? 'classic';

              return Expanded(
                child: ListView.separated(
                  itemCount: resources.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = resources[index];

                    String surahTitle = contextualTranslation(
                      locale: currentLang,
                      enText: item.surahTitle,
                      bnText: item.surahTitleBn,
                    );

                    Future goToPage() async {
                      String? surahId;

                      if (item.surahId != null) {
                        surahId = item.surahId;
                      } else {
                        var query = AllModelsQuery(
                          repository: ref.surahs,
                          params: {
                            'title': item.surahTitle,
                            'quantity': 1,
                            'offline': true,
                          },
                        );

                        var surah = await ref.watch(
                          firstModelProvider(query).future,
                        );

                        surahId = surah.id;
                      }

                      var query = AllModelsQuery(
                        repository: ref.quranBookPages,
                        params: {
                          'quranBookId': book.id,
                          'surahId': surahId,
                          'ayahNo': item.position,
                          'quantity': 1,
                          'offline': true,
                        },
                      );

                      var resources =
                          await ref.watch(allModelsProvider(query).future);

                      if (resources.isNotEmpty) {
                        var bookPage = resources.first;
                        pdfController.goToPage(
                          pageNumber: bookPage.position,
                        );
                      }

                      closeDrawer();
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: goToPage,
                                child: Row(
                                  children: [
                                    Text(
                                      '$surahTitle:',
                                      style: textTheme.titleMedium?.copyWith(
                                        color:
                                            AppTheme.titleContrastColor[theme],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      numFormatter.format(item.position),
                                      style: textTheme.titleMedium?.copyWith(
                                        color:
                                            AppTheme.titleContrastColor[theme],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<int>(
                                child: const SizedBox(
                                  width: 50,
                                  height: 40,
                                  child: Icon(Icons.more_vert),
                                ),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<int>>[
                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: Text(
                                      locales.goToPage,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Text(
                                      locales.remove,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                                onSelected: (int menuItem) async {
                                  switch (menuItem) {
                                    case 0:
                                      await goToPage();
                                      break;
                                    case 1:
                                      await ref
                                          .read(ayahBookmarksProvider.notifier)
                                          .deleteItem(item.id);
                                      break;
                                  }
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: Text(
                              item.title,
                              textDirection: TextDirection.rtl,
                              style: textTheme.labelMedium?.copyWith(
                                color: AppTheme.labelContrastColor[theme],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      color: AppTheme.separatorColor[theme],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/ayah_bookmarks.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/theme/app_theme.dart';

class QuranBookmarks extends ConsumerWidget {
  const QuranBookmarks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    var ayahBookmarks = ref.watch(ayahBookmarksProvider);

    return AppScaffold(
      title: Text(locales.savedAyahs),
      body: ayahBookmarks.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text(error.toString()),
        data: (resources) {
          return WithPreferences(
            builder: (context, preferences) {
              String theme = preferences.getString('theme') ?? 'classic';

              return ListView.separated(
                itemCount: resources.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = resources[index];

                  String surahTitle = contextualTranslation(
                    locale: currentLang,
                    enText: item.surahTitle,
                    bnText: item.surahTitleBn,
                  );

                  return Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$surahTitle:',
                              style: textTheme.headlineMedium,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              numFormatter.format(item.position),
                              style: textTheme.headlineMedium,
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
                                    locales.remove,
                                    style: textTheme.labelMedium,
                                  ),
                                ),
                              ],
                              onSelected: (int menuItem) async {
                                switch (menuItem) {
                                  case 0:
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
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                          ),
                          child: Text(
                            item.title,
                            textDirection: TextDirection.rtl,
                            style: textTheme.headlineLarge,
                          ),
                        ),
                        if (item.translation != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.only(top: 3),
                            child: HtmlText(text: item.translation),
                          ),
                        ],
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
              );
            },
          );
        },
      ),
    );
  }
}

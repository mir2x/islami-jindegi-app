import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/ayah_bookmarks.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/theme/colors.dart';

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
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ThemeColors.color4,
                    ),
                  ),
                ),
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('$surahTitle:', style: textTheme.headlineMedium),
                        const SizedBox(width: 5),
                        Text(
                          numFormatter.format(item.position),
                          style: textTheme.headlineMedium,
                        ),
                        PopupMenuButton<int>(
                          child: const SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(Icons.more_vert),
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                              value: 0,
                              child: Text(locales.remove),
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.only(top: 3),
                      child: Text(
                        item.title,
                        textDirection: TextDirection.rtl,
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    if (item.translation != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.only(top: 5),
                        child: HtmlText(text: item.translation),
                      ),
                    ],
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 2);
            },
          );
        },
      ),
    );
  }
}

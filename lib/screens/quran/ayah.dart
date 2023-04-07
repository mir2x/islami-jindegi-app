import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/audio/qirat.dart';
import 'package:native_app/theme/colors.dart';
import 'tafseer.dart';

class Ayah extends ConsumerWidget {
  const Ayah({
    super.key,
    required this.ayah,
    required this.chapter,
    required this.preferences,
  });

  final dynamic ayah;
  final dynamic chapter;
  final dynamic preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        double screenWidth = MediaQuery.of(context).size.width;
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
                            child: Tafseer(ayah: ayah),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    ayah.title,
                    textDirection: TextDirection.rtl,
                    style: textTheme.headlineMedium,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 42,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/ayah-symbol.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              numFormatter.format(ayah.surahPosition),
                              style: textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (qSettings.containsKey('qari') &&
                        chapter.runtimeType.toString() == 'Surah') ...[
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Qirat(
                          surah: chapter,
                          ayah: ayah,
                          qari: qSettings['qari'],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<int>(
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: Icon(Icons.more_vert),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  /* PopupMenuItem<int>( */
                  /*   value: 0, */
                  /*   child: Text(locales.bookmark), */
                  /* ), */
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(locales.copyAyah),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text(locales.share),
                  ),
                ],
                onSelected: (int item) async {
                  switch (item) {
                    case 1:
                      await Clipboard.setData(ClipboardData(text: ayah.title));
                      break;
                    case 2:
                      String chapterTitle = contextualTranslation(
                        locale: currentLang,
                        enText: chapter.title,
                        bnText: chapter.titleBn,
                      );

                      String ayahPosition = numFormatter.format(
                        ayah.surahPosition,
                      );

                      var text = ayah.title;

                      if (ayah.ayahTranslations.first.body != null) {
                        text += '\n\n${ayah.ayahTranslations.first.body}';
                      }

                      text += '\n\n$chapterTitle - $ayahPosition';

                      await Clipboard.setData(ClipboardData(text: text));

                      Share.share(
                        text,
                        subject: '$chapterTitle - $ayahPosition',
                      );
                      break;
                  }
                },
              ),
            ],
          ),
          if (qSettings.containsKey('translation') &&
              qSettings['translation'] &&
              ayah.ayahTranslations.first != null) ...[
            Container(
              margin: const EdgeInsets.only(top: 10, right: 15),
              child: Text(ayah.ayahTranslations.first.body),
            ),
          ],
        ],
      ),
    );
  }
}

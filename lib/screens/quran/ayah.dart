import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/audio/qirat.dart';
import 'package:native_app/providers/ayah_bookmarks.dart';

class Ayah extends ConsumerWidget {
  const Ayah({
    super.key,
    required this.ayah,
    required this.chapter,
    required this.preferences,
    required this.arabicFontSizeRatio,
    required this.banglaFontSizeRatio,
  });

  final dynamic ayah;
  final dynamic chapter;
  final dynamic preferences;
  final FontSizeRatio arabicFontSizeRatio;
  final FontSizeRatio banglaFontSizeRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    return Container(
      padding: const EdgeInsets.only(bottom: 20, left: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => QR.to('quran/tafseers/${ayah.id}'),
                  child: ValueListenableBuilder<double>(
                    valueListenable: arabicFontSizeRatio,
                    builder: (context, ratio, child) {
                      return Text(
                        ayah.title,
                        textDirection: TextDirection.rtl,
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 20 * ratio,
                        ),
                      );
                    },
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
                  width: 35,
                  child: Icon(Icons.more_vert),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(locales.saveAyah),
                  ),
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
                    case 0:
                      var query = SingleModelQuery(
                        repository: ref.ayahs,
                        id: ayah.id,
                        params: const {'include': 'surah,ayah-translations'},
                        remote: true,
                      );

                      var reloadedAyah = await ref.read(
                        singleModelProvider(query).future,
                      );

                      await ref
                          .read(ayahBookmarkProvider(ayah.id).notifier)
                          .createItem({
                        'ayahId': ayah.id,
                        'title': ayah.title,
                        if (ayah.ayahTranslations.isNotEmpty) ...{
                          'translation':
                              reloadedAyah.ayahTranslations.first.body
                        },
                        'position': ayah.surahPosition,
                        'surahTitle': reloadedAyah.surah.value.title,
                        'surahTitleBn': reloadedAyah.surah.value.titleBn,
                      });

                      break;
                    case 1:
                      await Clipboard.setData(ClipboardData(text: ayah.title));
                      break;
                    case 2:
                      var query = SingleModelQuery(
                        repository: ref.ayahs,
                        id: ayah.id,
                        params: const {'include': 'surah,ayah-translations'},
                        remote: true,
                      );

                      var reloadedAyah = await ref.read(
                        singleModelProvider(query).future,
                      );

                      String surahTitle = contextualTranslation(
                        locale: currentLang,
                        enText: reloadedAyah.surah.value.title,
                        bnText: reloadedAyah.surah.value.titleBn,
                      );

                      String ayahPosition = numFormatter.format(
                        ayah.surahPosition,
                      );

                      var text = ayah.title;

                      if (ayah.ayahTranslations.isNotEmpty) {
                        text += '\n\n${ayah.ayahTranslations.first.body}';
                      }

                      text += '\n\n$surahTitle - $ayahPosition';

                      await Clipboard.setData(ClipboardData(text: text));

                      Share.share(
                        text,
                        subject: '$surahTitle - $ayahPosition',
                      );

                      break;
                  }
                },
              ),
            ],
          ),
          if (qSettings.containsKey('translation') &&
              qSettings['translation'] &&
              ayah.ayahTranslations.isNotEmpty) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10, right: 15),
              child: ValueListenableBuilder<double>(
                valueListenable: banglaFontSizeRatio,
                builder: (context, ratio, child) {
                  return Text(
                    ayah.ayahTranslations.first.body,
                    style: textTheme.labelMedium?.copyWith(
                      fontSize: 16 * ratio,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

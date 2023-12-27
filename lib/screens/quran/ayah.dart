import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:html/parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/single_model.dart';
import 'package:native_app/objects/single_model_query.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/widgets/audio/qirat.dart';
import 'package:native_app/providers/ayah_bookmarks.dart';
import 'package:native_app/widgets/page/html_body.dart';

class Ayah extends ConsumerWidget {
  const Ayah({
    super.key,
    required this.ayah,
    required this.chapter,
    required this.preferences,
    required this.arabicFontSizeRatio,
    required this.banglaFontSizeRatio,
    this.markAdjustment = 0,
  });

  final dynamic ayah;
  final dynamic chapter;
  final dynamic preferences;
  final FontSizeRatio arabicFontSizeRatio;
  final FontSizeRatio banglaFontSizeRatio;
  final double markAdjustment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);

    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15 + markAdjustment),
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
                        ayah.title.trim(),
                        textDirection: TextDirection.rtl,
                        style: textTheme.labelLarge?.copyWith(
                          fontSize: 28 * ratio,
                          height: 1.5,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 5),
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
                      QiratButton(
                        surah: chapter,
                        ayah: ayah,
                        qari: qSettings['qari'],
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<int>(
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: const SizedBox(
                    height: 40,
                    width: 35,
                    child: Icon(Icons.more_vert),
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(locales.readTafseer),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(locales.saveAyah),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text(locales.copyAyah),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text(locales.share),
                  ),
                ],
                onSelected: (int item) async {
                  switch (item) {
                    case 0:
                      QR.to('quran/tafseers/${ayah.id}');
                      break;
                    case 1:
                      var query = SingleModelQuery(
                        repository: ref.ayahs,
                        id: ayah.id,
                        params: const {'include': 'surah,ayah-translations'},
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
                              reloadedAyah.ayahTranslations.first.body,
                        },
                        'position': ayah.surahPosition,
                        'surahTitle': reloadedAyah.surah.value.title,
                        'surahTitleBn': reloadedAyah.surah.value.titleBn,
                      });

                      break;
                    case 2:
                      await Clipboard.setData(ClipboardData(text: ayah.title));
                      break;
                    case 3:
                      var query = SingleModelQuery(
                        repository: ref.ayahs,
                        id: ayah.id,
                        params: const {'include': 'surah,ayah-translations'},
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
                        final document =
                            parse(ayah.ayahTranslations.first.body);
                        List pList = document.querySelectorAll('p');

                        if (pList.isNotEmpty) {
                          text += '\n\n';
                          for (var p in pList) {
                            if (p.text != '') {
                              text += '${p.text}\n\n';
                            }
                          }
                        }
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
              margin: EdgeInsets.only(left: markAdjustment, right: 15),
              child: PageHtmlBody(
                text: ayah.ayahTranslations.first.body,
                fontSizeRatio: banglaFontSizeRatio,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class QiratButton extends StatefulWidget {
  const QiratButton({
    super.key,
    required this.surah,
    required this.ayah,
    required this.qari,
  });

  final dynamic surah;
  final dynamic ayah;
  final String qari;

  @override
  State<QiratButton> createState() => _QiratButtonState();
}

class _QiratButtonState extends State<QiratButton> {
  bool playerLoaded = false;

  void loadPlayer() {
    setState(() => playerLoaded = true);
  }

  @override
  @mustCallSuper
  void didUpdateWidget(covariant oldwidget) {
    super.didUpdateWidget(oldwidget);
    if (widget.qari != oldwidget.qari) {
      setState(() => playerLoaded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: playerLoaded
          ? Qirat(
              surah: widget.surah,
              ayah: widget.ayah,
              qari: widget.qari,
            )
          : InkWell(
              onTap: loadPlayer,
              child: SvgPicture.asset(
                'assets/images/icons/play.svg',
                width: 30,
                height: 30,
              ),
            ),
    );
  }
}

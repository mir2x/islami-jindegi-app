import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:flutter_svg/svg.dart';
import 'package:native_app/helpers/contextual_translation.dart';
import 'package:native_app/objects/font_size_ratio.dart';
import 'package:native_app/objects/qirat_audio.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/providers/qirat_player.dart';
import 'package:native_app/providers/check_downloaded_file.dart';
import 'package:native_app/widgets/page/html_body.dart';
import 'package:native_app/theme/app_theme.dart';
import 'ayah_actions.dart';

class Ayah extends ConsumerWidget {
  const Ayah({
    super.key,
    required this.ayah,
    required this.chapter,
    required this.qari,
    required this.isActive,
    required this.isPlaying,
    required this.loadQirat,
    required this.preferences,
    required this.arabicFontSizeRatio,
    required this.banglaFontSizeRatio,
    this.markAdjustment = 0,
  });

  final dynamic ayah;
  final dynamic chapter;
  final String? qari;
  final bool isActive;
  final bool isPlaying;
  final Future? Function(dynamic) loadQirat;
  final dynamic preferences;
  final FontSizeRatio arabicFontSizeRatio;
  final FontSizeRatio banglaFontSizeRatio;
  final double markAdjustment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    var textTheme = Theme.of(context).textTheme;
    var qSettings = ref.watch(quranSettingsProvider);
    String theme = preferences.getString('theme') ?? 'classic';

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 15 + markAdjustment,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.activeAyahColor[theme] : null,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: SizedBox(
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
                ),
                Row(
                  children: [
                    if (qari != null &&
                        chapter.runtimeType.toString() == 'Surah') ...[
                      QiratButton(
                        ayah: ayah,
                        chapter: chapter,
                        qari: qari!,
                        loadQirat: loadQirat,
                        isActive: isActive,
                        isPlaying: isPlaying,
                      ),
                    ],
                    AyahActions(ayah: ayah),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => QR.to('quran/tafseers/${ayah.id}'),
            child: ValueListenableBuilder<double>(
              valueListenable: arabicFontSizeRatio,
              builder: (context, ratio, child) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: markAdjustment,
                    right: 15,
                    bottom: 5,
                  ),
                  child: Text(
                    ayah.title.trim(),
                    textDirection: TextDirection.rtl,
                    style: textTheme.labelLarge?.copyWith(
                      fontSize: 27 * ratio,
                      height: 1.6,
                    ),
                  ),
                );
              },
            ),
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

class QiratButton extends StatelessWidget {
  const QiratButton({
    super.key,
    required this.ayah,
    required this.chapter,
    required this.qari,
    required this.isActive,
    required this.isPlaying,
    required this.loadQirat,
  });

  final dynamic ayah;
  final dynamic chapter;
  final String qari;
  final bool isActive;
  final bool isPlaying;
  final Future? Function(dynamic) loadQirat;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return QiratPlayer(
        ayah: ayah,
        chapter: chapter,
        qari: qari,
        isPlaying: isPlaying,
        loadQirat: loadQirat,
      );
    } else {
      return InkWell(
        onTap: () async => await loadQirat(ayah),
        child: PlayButton(
          ayah: ayah,
          chapter: chapter,
          qari: qari,
        ),
      );
    }
  }
}

class PlayButton extends ConsumerWidget {
  const PlayButton({
    super.key,
    required this.ayah,
    required this.chapter,
    required this.qari,
  });

  final dynamic ayah;
  final dynamic chapter;
  final String qari;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String filePath =
        'al-quran/qirats/$qari/${chapter.position}/${ayah.surahPosition}.mp3';
    var checkDownloaded = ref.watch(checkDownloadedFileProvider(filePath));

    Widget defaultButton = SvgPicture.asset(
      'assets/images/icons/play.svg',
      width: 30,
      height: 30,
    );

    return checkDownloaded.when(
      loading: () => defaultButton,
      error: (error, _) => defaultButton,
      data: (isDownloaded) {
        if (isDownloaded) {
          return SvgPicture.asset(
            'assets/images/icons/play-offline.svg',
            width: 30,
            height: 30,
          );
        } else {
          return defaultButton;
        }
      },
    );
  }
}

class QiratPlayer extends ConsumerWidget {
  const QiratPlayer({
    super.key,
    required this.ayah,
    required this.chapter,
    required this.qari,
    required this.isPlaying,
    required this.loadQirat,
  });

  final dynamic ayah;
  final dynamic chapter;
  final String qari;
  final bool isPlaying;
  final Future? Function(dynamic) loadQirat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var numFormatter = NumberFormat('#', currentLang);
    String audioPath = '$qari/${chapter.position}/${ayah.surahPosition}.mp3';
    String? nextAudioPath;

    if (ayah.surahPosition + 1 <= chapter.totalAyat) {
      nextAudioPath = '$qari/${chapter.position}/${ayah.surahPosition + 1}.mp3';
    }

    var qiratProvider = ref.watch(
      qiratPlayerProvider(
        QiratAudio(
          surah: contextualTranslation(
            locale: currentLang,
            enText: chapter.title,
            bnText: chapter.titleBn,
          ),
          ayah: numFormatter.format(ayah.surahPosition),
          audioPath: audioPath,
          nextAudioPath: nextAudioPath,
          autoPlay: true,
        ),
      ),
    );

    return qiratProvider.when(
      loading: () => SvgPicture.asset(
        'assets/images/icons/pause-offline.svg',
        width: 30,
        height: 30,
      ),
      error: (error, _) => InkWell(
        onTap: () async => await loadQirat(ayah),
        child: PlayButton(
          ayah: ayah,
          chapter: chapter,
          qari: qari,
        ),
      ),
      data: (updatedPlayer) {
        return InkWell(
          onTap: () async {
            if (isPlaying) {
              await updatedPlayer.pause();
            } else {
              await updatedPlayer.play();
            }
          },
          child: isPlaying
              ? SvgPicture.asset(
                  'assets/images/icons/pause-offline.svg',
                  width: 30,
                  height: 30,
                )
              : PlayButton(
                  ayah: ayah,
                  chapter: chapter,
                  qari: qari,
                ),
        );
      },
    );
  }
}

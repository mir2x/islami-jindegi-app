import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/qirat_player.dart';
import 'package:native_app/providers/bismillah_player.dart';
import 'package:native_app/objects/qirat_audio.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/widgets/presentation/popup_dialog.dart';
import 'package:native_app/theme/app_theme.dart';

class QuranBookPlayer extends ConsumerStatefulWidget {
  const QuranBookPlayer({
    super.key,
    required this.player,
    required this.qari,
    required this.surahId,
    required this.surahNo,
    required this.surahTitle,
    required this.fromAyah,
    required this.toAyah,
    required this.preferences,
  });

  final AudioPlayer player;
  final String qari;
  final String surahId;
  final int surahNo;
  final String surahTitle;
  final int fromAyah;
  final int toAyah;
  final dynamic preferences;

  @override
  ConsumerState createState() => _QuranBookPlayerState();
}

class _QuranBookPlayerState extends ConsumerState<QuranBookPlayer> {
  StreamSubscription? _playerStateSubscription;
  bool isPlaying = false;

  int currentAyah = -1;

  updateCurrentAyah(ayah) {
    setState(() => currentAyah = ayah);
  }

  @override
  void initState() {
    super.initState();

    currentAyah = widget.fromAyah;

    _playerStateSubscription =
        widget.player.playerStateStream.listen((PlayerState s) {
      setState(() {
        if (s.processingState == ProcessingState.completed) {
          if (currentAyah < widget.toAyah) {
            currentAyah = currentAyah + 1;
          } else {
            widget.player.pause();
            widget.player.seek(const Duration(seconds: 0));
          }
        }

        isPlaying = s.playing;
      });
    });
  }

  @override
  void didUpdateWidget(covariant oldwidget) {
    super.didUpdateWidget(oldwidget);

    setState(() {
      bool pageChanged = widget.fromAyah != oldwidget.fromAyah;
      bool surahChanged = widget.surahNo != oldwidget.surahNo;

      if (pageChanged || surahChanged) {
        currentAyah = widget.fromAyah;

        if (currentAyah == 1 && widget.surahNo != 9) {
          currentAyah = 0;
          ref.read(bismillahPlayerProvider);
        }
      }
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _playerStateSubscription?.cancel();
    await widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    String currentLang = Localizations.localeOf(context).languageCode;
    var locales = AppLocalizations.of(context)!;
    var numFormatter = NumberFormat('#', currentLang);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallMobile = screenWidth < 340;
    String theme = widget.preferences.getString('theme') ?? 'classic';
    var textTheme = Theme.of(context).textTheme;
    String audioPath = '${widget.qari}/${widget.surahNo}/$currentAyah.mp3';
    String? nextAudioPath;

    if (currentAyah + 1 <= widget.toAyah) {
      nextAudioPath = '${widget.qari}/${widget.surahNo}/${currentAyah + 1}.mp3';
    }

    var qiratProvider = ref.watch(
      qiratPlayerProvider(
        QiratAudio(
          surah: widget.surahTitle,
          ayah: numFormatter.format(currentAyah),
          audioPath: audioPath,
          nextAudioPath: nextAudioPath,
        ),
      ),
    );

    Widget currentAyahText = Text(
      numFormatter.format(currentAyah),
      style: textTheme.titleMedium?.copyWith(
        color: AppTheme.titleContrastColor[theme],
      ),
    );

    return qiratProvider.when(
      loading: () => Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SvgPicture.asset(
              'assets/images/icons/pause.svg',
              width: 30,
              height: 30,
            ),
          ),
          currentAyahText,
        ],
      ),
      error: (error, _) => InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SvgPicture.asset(
            'assets/images/icons/play.svg',
            width: 30,
            height: 30,
          ),
        ),
      ),
      data: (updatedPlayer) {
        return Row(
          children: [
            InkWell(
              onTap: () async {
                if (isPlaying) {
                  await updatedPlayer.pause();
                } else {
                  await updatedPlayer.play();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: isPlaying
                    ? SvgPicture.asset(
                        'assets/images/icons/pause.svg',
                        width: 30,
                        height: 30,
                      )
                    : SvgPicture.asset(
                        'assets/images/icons/play.svg',
                        width: 30,
                        height: 30,
                      ),
              ),
            ),
            currentAyahText,
            const SizedBox(width: 5),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.all(isSmallMobile ? 0 : 5),
              ),
              child: Text(
                locales.translation,
                style: textTheme.titleMedium?.copyWith(
                  color: AppTheme.titleContrastColor[theme],
                ),
              ),
              onPressed: () async {
                var translations = await ref.ayahTranslations.findAll(
                  params: {
                    'ayahNo': currentAyah,
                    'surahId': widget.surahId,
                    'quantity': 1,
                  },
                );

                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      var textTheme = Theme.of(context).textTheme;
                      var item = translations.first;

                      return PopupDialog(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.surahTitle,
                                        style: textTheme.headlineMedium,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        ', ${locales.ayah}: ${numFormatter.format(currentAyah)}',
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: HtmlText(text: item.body),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

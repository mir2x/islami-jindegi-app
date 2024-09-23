import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/providers/qirat_player.dart';
import 'package:native_app/providers/bismillah_player.dart';
import 'package:native_app/providers/quran_settings.dart';
import 'package:native_app/objects/qirat_audio.dart';

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
  });

  final AudioPlayer player;
  final String qari;
  final String surahId;
  final int surahNo;
  final String surahTitle;
  final int fromAyah;
  final int toAyah;

  @override
  ConsumerState createState() => _QuranBookPlayerState();
}

class _QuranBookPlayerState extends ConsumerState<QuranBookPlayer> {
  StreamSubscription? _playerStateSubscription;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    _playerStateSubscription =
        widget.player.playerStateStream.listen((PlayerState s) {
      setState(() {
        if (s.processingState == ProcessingState.completed) {
          var qSettings = ref.watch(quranSettingsProvider);

          int? currentAyah = qSettings.containsKey('currentAyah')
              ? qSettings['currentAyah']
              : null;

          if (currentAyah != null && (currentAyah < widget.toAyah)) {
            var notifier = ref.read(quranSettingsProvider.notifier);
            notifier.updateParams('currentAyah', currentAyah + 1);
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
      bool surahChanged = widget.surahNo != oldwidget.surahNo;

      if (surahChanged) {
        widget.player.stop();
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
    var qSettings = ref.watch(quranSettingsProvider);

    int? currentAyah =
        qSettings.containsKey('currentAyah') ? qSettings['currentAyah'] : null;

    if (currentAyah != null) {
      if (currentAyah == 0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () {
              if (!isPlaying) {
                String firstAyahPath = '${widget.qari}/${widget.surahNo}/1.mp3';
                ref.read(bismillahPlayerProvider(firstAyahPath));
              }
            },
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
        );
      } else {
        String currentLang = Localizations.localeOf(context).languageCode;
        var numFormatter = NumberFormat('#', currentLang);
        String audioPath = '${widget.qari}/${widget.surahNo}/$currentAyah.mp3';
        String? nextAudioPath;

        if (currentAyah + 1 <= widget.toAyah) {
          nextAudioPath =
              '${widget.qari}/${widget.surahNo}/${currentAyah + 1}.mp3';
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

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: qiratProvider.when(
            loading: () => Row(
              children: [
                SvgPicture.asset(
                  'assets/images/icons/pause.svg',
                  width: 30,
                  height: 30,
                ),
              ],
            ),
            error: (error, _) => InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/images/icons/play.svg',
                width: 30,
                height: 30,
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
                ],
              );
            },
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

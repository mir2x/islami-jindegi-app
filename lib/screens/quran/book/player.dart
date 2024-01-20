import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:native_app/providers/qirat_player.dart';
import 'package:native_app/objects/qirat_audio.dart';

class QuranBookPlayer extends ConsumerStatefulWidget {
  const QuranBookPlayer({
    super.key,
    required this.player,
    required this.qari,
    required this.surahNo,
    required this.surahTitle,
    required this.fromAyah,
    required this.toAyah,
  });

  final AudioPlayer player;
  final String qari;
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

  int currentAyah = 0;

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
    var numFormatter = NumberFormat('#', currentLang);
    String audioPath = '${widget.qari}/${widget.surahNo}/$currentAyah.mp3';

    var qiratProvider = ref.watch(
      qiratPlayerProvider(
        QiratAudio(
          audioPath: audioPath,
          surah: widget.surahTitle,
          ayah: numFormatter.format(currentAyah),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: qiratProvider.when(
        loading: () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SvgPicture.asset(
            'assets/images/icons/play.svg',
            width: 30,
            height: 30,
          ),
        ),
        error: (error, _) => InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SvgPicture.asset(
              'assets/images/icons/play.svg',
              width: 30,
              height: 30,
            ),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
        },
      ),
    );
  }
}

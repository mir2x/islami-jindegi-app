import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/qirat_player.dart';
import 'package:native_app/objects/qirat_player_audio.dart';

class QuranBookPlayer extends ConsumerStatefulWidget {
  const QuranBookPlayer({
    super.key,
    required this.qari,
    required this.surah,
    required this.fromAyah,
    required this.toAyah,
  });

  final String qari;
  final int surah;
  final int fromAyah;
  final int toAyah;

  @override
  ConsumerState createState() => _QuranBookPlayerState();
}

class _QuranBookPlayerState extends ConsumerState<QuranBookPlayer> {
  AudioPlayer player = AudioPlayer();
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

    _playerStateSubscription = player.playerStateStream.listen((PlayerState s) {
      setState(() {
        if (s.processingState == ProcessingState.completed) {
          if (currentAyah < widget.toAyah) {
            currentAyah = currentAyah + 1;
          } else {
            player.pause();
            player.seek(const Duration(seconds: 0));
          }
        }

        isPlaying = s.playing;
      });
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _playerStateSubscription?.cancel();
    await player.stop();
  }

  @override
  Widget build(BuildContext context) {
    String audioPath = '${widget.qari}/${widget.surah}/$currentAyah.mp3';

    var qiratProvider = ref.watch(
      qiratPlayerProvider(
        QiratPlayerAudio(
          player: player,
          audioPath: audioPath,
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: qiratProvider.when(
        loading: () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SvgPicture.asset(
            'assets/images/icons/pause.svg',
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

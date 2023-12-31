import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:native_app/providers/qirat_player.dart';
import 'package:native_app/objects/qirat_player_audio.dart';

class Qirat extends ConsumerWidget {
  const Qirat({
    super.key,
    required this.surah,
    required this.ayah,
    required this.qari,
    required this.player,
  });

  final dynamic surah;
  final dynamic ayah;
  final String qari;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String audioPath = '$qari/${surah.position}/${ayah.surahPosition}.mp3';
    var audioPlayer = ref.watch(
      qiratPlayerProvider(
        QiratPlayerAudio(
          player: player,
          audioPath: audioPath,
        ),
      ),
    );

    return audioPlayer.when(
      loading: () => SvgPicture.asset(
        'assets/images/icons/pause.svg',
        width: 30,
        height: 30,
      ),
      error: (error, _) {
        if (error.toString() == 'Exception: no connection') {
          return const Icon(
            Icons.signal_wifi_connected_no_internet_4,
            size: 30,
          );
        } else {
          return const Icon(Icons.play_disabled, size: 30);
        }
      },
      data: (sPlayer) {
        return StatefulQiratPlayer(player: sPlayer);
      },
    );
  }
}

class StatefulQiratPlayer extends StatefulWidget {
  const StatefulQiratPlayer({
    super.key,
    required this.player,
  });

  final AudioPlayer player;

  @override
  State<StatefulQiratPlayer> createState() => _QiratPlayerState();
}

class _QiratPlayerState extends State<StatefulQiratPlayer> {
  bool isPlaying = true;

  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();

    _playerStateSubscription =
        widget.player.playerStateStream.listen((PlayerState s) {
      setState(() {
        if (s.processingState == ProcessingState.completed) {
          widget.player.pause();
          widget.player.seek(const Duration(seconds: 0));
        }

        isPlaying = s.playing;
      });
    });

    widget.player.play();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _playerStateSubscription?.cancel();
    await widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            if (isPlaying) {
              await widget.player.pause();
            } else {
              await widget.player.play();
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
  }
}

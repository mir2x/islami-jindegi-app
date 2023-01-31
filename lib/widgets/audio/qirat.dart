import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:native_app/providers/audio_player.dart';

class Qirat extends ConsumerWidget {
  const Qirat({
    super.key,
    required this.surah,
    required this.ayah,
    required this.qari,
  });

  final dynamic surah;
  final dynamic ayah;
  final String qari;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String src =
        '${dotenv.env['STATIC_HOST_NAME']}/assets/al-quran/qirats/$qari/${surah.position}/${ayah.surahPosition}.mp3';

    var audioPlayer = ref.watch(audioPlayerProvider(src));

    return audioPlayer.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => Text(error.toString()),
      data: (player) {
        return StatefulQiratPlayer(player: player);
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
  PlayerState _playerState = PlayerState.stopped;

  StreamSubscription? _playerStateSubscription;

  bool get isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();

    _playerStateSubscription =
        widget.player.onPlayerStateChanged.listen((PlayerState s) {
      setState(() => _playerState = s);
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
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (isPlaying) {
              await widget.player.pause();
            } else {
              await widget.player.resume();
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

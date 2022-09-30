import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:native_app/styles/settings/theme_colors.dart';
import 'package:native_app/helpers/play_time.dart';

class AudioPlayerWidget extends StatefulWidget {
  AudioPlayerWidget({
    super.key,
    required this.audio,
  });

  final LinkedHashMap audio;
  final AudioPlayer player = AudioPlayer(playerId: 'unique_player_id');

  @override
  State<StatefulWidget> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayerWidget> {
  PlayerState _playerState = PlayerState.stopped;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;

  Duration duration = const Duration();
  Duration position = const Duration();

  bool get isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();

    _durationSubscription = widget.player.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });

    _positionSubscription = widget.player.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });

    _playerStateSubscription = widget.player.onPlayerStateChanged.listen((PlayerState s) {
      setState(() => _playerState = s);
    });

    _playerCompleteSubscription = widget.player.onPlayerComplete.listen((event) {
      setState(() => position = Duration.zero);
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await widget.player.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    UrlSource source = UrlSource("${dotenv.env['STATIC_HOST_NAME']}/uploads/${widget.audio['storage']}/${widget.audio['id']}");

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (isPlaying) {
              await widget.player.pause();
            } else {
              await widget.player.play(source);
            }
          },
          child: isPlaying ? SvgPicture.asset(
            'assets/images/icons/pause.svg',
            width: 80,
            height: 80,
          ) : SvgPicture.asset(
            'assets/images/icons/play.svg',
            width: 80,
            height: 80,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                playTime(position.inSeconds),
                style: TextStyle(color: ThemeColors().themeColor4),
              ),
              Text(
                playTime(duration.inSeconds),
                style: TextStyle(color: ThemeColors().themeColor4),
              ),
            ]
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: SliderComponentShape.noThumb,
          ),
          child: Slider(
            activeColor: ThemeColors().themeColor4,
            inactiveColor: ThemeColors().themeColor3,
            value: position.inSeconds.toDouble(),
            min: 0,
            max: duration.inSeconds.toDouble(),
            onChanged: (double value) async {
              await widget.player.seek(Duration(seconds: value.toInt()));
              value = value;
            },
          ),
        ),
      ]
    );
  }
}

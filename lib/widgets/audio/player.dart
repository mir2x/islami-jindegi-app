import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:native_app/providers/audio_player.dart';
import 'package:native_app/objects/audio_resource.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/helpers/play_time.dart';

class AudioPlayerWidget extends ConsumerWidget {
  const AudioPlayerWidget({
    super.key,
    required this.audio,
    required this.album,
    required this.title,
  });

  final Map audio;
  final String album;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var audioSource = AudioResource(
      id: audio['id'],
      storage: audio['storage'],
      album: album,
      title: title,
    );

    var audioPlayer = ref.watch(audioPlayerProvider(audioSource));

    return audioPlayer.when(
      loading: () => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 78, bottom: 77),
          child: const CircularProgressIndicator(),
        ),
      ),
      error: (error, _) {
        return Center(
          child: Container(
            margin: const EdgeInsets.only(top: 49, bottom: 48),
            child: const ConnectToInternet(),
          ),
        );
      },
      data: (updatedPlayer) {
        return StatefulAudioPlayer(
          player: updatedPlayer,
          audio: audio,
          title: title,
        );
      },
    );
  }
}

class StatefulAudioPlayer extends ConsumerStatefulWidget {
  const StatefulAudioPlayer({
    super.key,
    required this.player,
    required this.audio,
    required this.title,
  });

  final AudioPlayer player;
  final Map audio;
  final String title;

  @override
  ConsumerState<StatefulAudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends ConsumerState<StatefulAudioPlayer> {
  bool isPlaying = false;
  bool isIdle = true;

  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playbackEventSubscription;

  Duration duration = const Duration();
  Duration position = const Duration();

  @override
  void initState() {
    super.initState();

    if (widget.audio['metadata']?['duration'] != null) {
      dynamic seconds = widget.audio['metadata']?['duration'];

      if (seconds is String) {
        seconds = int.parse(seconds);
      }

      duration = Duration(seconds: seconds);
    }

    _playerStateSubscription = widget.player.playerStateStream.listen(
      (PlayerState s) {
        setState(() {
          if (s.processingState == ProcessingState.completed) {
            widget.player.pause();
            widget.player.seek(const Duration(seconds: 0));
          }

          isPlaying = s.playing;
          isIdle = s.processingState == ProcessingState.idle;
        });
      },
    );

    _durationSubscription = widget.player.durationStream.listen((Duration? d) {
      setState(() {
        if (d != null) {
          duration = d;
        }
      });
    });

    _positionSubscription = widget.player.positionStream.listen((Duration p) {
      setState(() => position = p);
    });

    _playbackEventSubscription = widget.player.playbackEventStream.listen(
      (event) {
        if (isPlaying && (event.processingState == ProcessingState.idle)) {
          EasyDebounce.debounce('player-idle', const Duration(seconds: 10), () {
            if (isPlaying && isIdle) {
              widget.player.stop();
            }
          });
        }
      },
      onError: (Object e, StackTrace st) {
        if (e is PlatformException) {
          widget.player.stop();
        } else {}
      },
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _playerStateSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _playbackEventSubscription?.cancel();
    await widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Column(
      children: [
        GestureDetector(
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
                  width: 80,
                  height: 80,
                )
              : SvgPicture.asset(
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
                style: textTheme.titleMedium,
              ),
              Text(
                playTime(duration.inSeconds),
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: SliderComponentShape.noThumb,
          ),
          child: Slider(
            activeColor: colors.active,
            inactiveColor: colors.divider,
            value: position.inSeconds.toDouble(),
            min: 0,
            max: duration.inSeconds.toDouble() + 2,
            onChanged: (double value) async {
              await widget.player.seek(Duration(seconds: value.toInt()));
              value = value;
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.fast_rewind),
              onPressed: () async {
                int tenSecondBehind = position.inSeconds - 10;

                if (tenSecondBehind >= 0) {
                  await widget.player.seek(Duration(seconds: tenSecondBehind));
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.fast_forward),
              onPressed: () async {
                int tenSecondForward = position.inSeconds + 10;

                if (tenSecondForward <= duration.inSeconds) {
                  await widget.player.seek(Duration(seconds: tenSecondForward));
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

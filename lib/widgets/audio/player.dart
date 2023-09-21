import 'dart:collection';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/audio_player.dart';
import 'package:native_app/providers/connectivity_result.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/objects/audio_source.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/helpers/play_time.dart';
import 'package:native_app/theme/colors.dart';

class AudioPlayerWidget extends ConsumerWidget {
  const AudioPlayerWidget({
    super.key,
    required this.audio,
  });

  final LinkedHashMap audio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var audioSource = AudioSource(id: audio['id'], storage: audio['storage']);
    var connectivity = ref.watch(connectivityResultProvider);

    return connectivity.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          var audioPlayer = ref.watch(audioPlayerProvider(audioSource));

          return audioPlayer.when(
            loading: () => Center(
              child: Container(
                margin: const EdgeInsets.all(54),
                child: const CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text(error.toString()),
            data: (player) {
              return StatefulAudioPlayer(
                player: player,
                audio: audio,
              );
            },
          );
        } else {
          var audioPlayer = ref.watch(localAudioPlayerProvider(audioSource));

          return audioPlayer.when(
            loading: () => Center(
              child: Container(
                margin: const EdgeInsets.all(54),
                child: const CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Text(error.toString()),
            data: (player) {
              if (player != null) {
                return StatefulAudioPlayer(
                  player: player,
                  audio: audio,
                );
              } else {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 27, bottom: 26),
                    child: const ConnectToInternet(),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}

class StatefulAudioPlayer extends ConsumerStatefulWidget {
  const StatefulAudioPlayer({
    super.key,
    required this.player,
    required this.audio,
  });

  final AudioPlayer player;
  final LinkedHashMap audio;

  @override
  ConsumerState<StatefulAudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends ConsumerState<StatefulAudioPlayer> {
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

    if (widget.audio['metadata']?['duration'] != null) {
      dynamic seconds = widget.audio['metadata']?['duration'];

      if (seconds is String) {
        seconds = int.parse(seconds);
      }

      duration = Duration(seconds: seconds);
    }

    _durationSubscription =
        widget.player.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });

    _positionSubscription =
        widget.player.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });

    _playerStateSubscription =
        widget.player.onPlayerStateChanged.listen((PlayerState s) {
      setState(() => _playerState = s);
    });

    _playerCompleteSubscription =
        widget.player.onPlayerComplete.listen((event) {
      setState(() => position = Duration.zero);
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _durationSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _playerCompleteSubscription?.cancel();
    await widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var prefs = ref.watch(preferencesProvider);

    return prefs.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => Text(error.toString()),
      data: (preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

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
                    style: textTheme.labelMedium?.copyWith(
                      color: theme == 'dark'
                          ? ThemeColors.color4
                          : ThemeColors.color8,
                    ),
                  ),
                  Text(
                    playTime(duration.inSeconds),
                    style: textTheme.labelMedium?.copyWith(
                      color: theme == 'dark'
                          ? ThemeColors.color4
                          : ThemeColors.color8,
                    ),
                  ),
                ],
              ),
            ),
            SliderTheme(
              data: SliderThemeData(
                overlayShape: SliderComponentShape.noThumb,
              ),
              child: Slider(
                activeColor:
                    theme == 'dark' ? ThemeColors.color4 : ThemeColors.color8,
                inactiveColor:
                    theme == 'dark' ? ThemeColors.color3 : ThemeColors.color9,
                value: position.inSeconds.toDouble(),
                min: 0,
                max: duration.inSeconds.toDouble(),
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
                      await widget.player
                          .seek(Duration(seconds: tenSecondBehind));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.fast_forward),
                  onPressed: () async {
                    int tenSecondForward = position.inSeconds + 10;

                    if (tenSecondForward <= duration.inSeconds) {
                      await widget.player
                          .seek(Duration(seconds: tenSecondForward));
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

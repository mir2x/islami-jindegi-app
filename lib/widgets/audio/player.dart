import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/providers/audio_player.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/objects/audio_resource.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/play_time.dart';
import 'package:native_app/theme/app_theme.dart';

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
      (event) {},
      onError: (Object e, StackTrace st) {
        if (e is PlatformException) {
          widget.player.pause();
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
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    Future<bool> canSeek() async {
      var scaffoldMessenger = ScaffoldMessenger.of(context);

      bool hasNoConnection =
          await Connectivity().checkConnectivity() == ConnectivityResult.none;

      String filePath = fileTitlePath(widget.title, widget.audio['id']);
      var localFile = await ref.watch(localFileProvider(filePath).future);

      if (hasNoConnection && localFile == null) {
        scaffoldMessenger.removeCurrentSnackBar();

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi),
                const SizedBox(width: 10),
                Text(
                  locales.connectToInternetMsg,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            duration: const Duration(seconds: 5),
          ),
        );

        return false;
      } else {
        return true;
      }
    }

    return WithPreferences(
      builder: (context, preferences) {
        String theme = preferences.getString('theme') ?? 'dark';

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
                activeColor: AppTheme.sliderFgColor[theme],
                inactiveColor: AppTheme.sliderBgColor[theme],
                value: position.inSeconds.toDouble(),
                min: 0,
                max: duration.inSeconds.toDouble() + 2,
                onChanged: (double value) async {
                  if (await canSeek()) {
                    await widget.player.seek(Duration(seconds: value.toInt()));
                    value = value;
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.fast_rewind),
                  onPressed: () async {
                    if (await canSeek()) {
                      int tenSecondBehind = position.inSeconds - 10;

                      if (tenSecondBehind >= 0) {
                        await widget.player
                            .seek(Duration(seconds: tenSecondBehind));
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.fast_forward),
                  onPressed: () async {
                    if (await canSeek()) {
                      int tenSecondForward = position.inSeconds + 10;

                      if (tenSecondForward <= duration.inSeconds) {
                        await widget.player
                            .seek(Duration(seconds: tenSecondForward));
                      }
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

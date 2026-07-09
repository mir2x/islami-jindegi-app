import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/player.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/play_time.dart';
import 'package:native_app/widgets/presentation/connect_to_internet.dart';
import 'package:native_app/theme/app_theme_color.dart';

/// Identifies one malfuzat's audio for the player provider family below.
class MalfuzatAudioSource extends Equatable {
  const MalfuzatAudioSource({
    required this.malfuzatId,
    required this.audioUrl,
    required this.title,
  });

  final String malfuzatId;
  final String audioUrl;
  final String title;

  @override
  List<Object> get props => [malfuzatId, audioUrl, title];
}

// Tracks which malfuzat audio currently "owns" the shared player, mirroring
// `providers/audio_player.dart`'s ownership pattern so a disposing provider
// doesn't stop audio that a newer provider has already taken over.
final _currentMalfuzatAudioIdProvider = StateProvider<String?>((ref) => null);

/// Prepares playback for a malfuzat's audio. Unlike the legacy shared
/// `audioPlayerProvider` (still used by bayan/dua/masail), which reconstructs
/// a stream URL from a JSON:API `{id, storage}` map via `fileSrcUrl`, the
/// .NET API already returns a complete `audioUrl`, so this plays that
/// directly — falling back to a locally downloaded copy if one exists at the
/// same path `DownloadItem` saves to.
final malfuzatAudioPlayerProvider = FutureProvider.autoDispose
    .family<AudioPlayer, MalfuzatAudioSource>((ref, source) async {
  final AudioPlayer player = ref.read(playerProvider);

  ref.onDispose(() async {
    if (ref.read(_currentMalfuzatAudioIdProvider) == source.malfuzatId) {
      await player.stop();
    }
  });

  final filePath =
      fileTitlePath(source.title, 'malfuzats/${source.malfuzatId}');
  final localFile = await ref.read(localFileProvider(filePath).future);

  ref.read(_currentMalfuzatAudioIdProvider.notifier).state = source.malfuzatId;

  if (localFile != null) {
    await player.stop();
    await player.setAudioSource(AudioSource.file(localFile.path));
  } else {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw Exception('no connection');
    }
    await player.stop();
    await player.setAudioSource(AudioSource.uri(Uri.parse(source.audioUrl)));
  }

  return player;
});

class MalfuzatAudioPlayerWidget extends ConsumerWidget {
  const MalfuzatAudioPlayerWidget({
    super.key,
    required this.malfuzatId,
    required this.audioUrl,
    required this.title,
  });

  final String malfuzatId;
  final String audioUrl;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = MalfuzatAudioSource(
      malfuzatId: malfuzatId,
      audioUrl: audioUrl,
      title: title,
    );
    final audioPlayer = ref.watch(malfuzatAudioPlayerProvider(source));

    return audioPlayer.when(
      loading: () => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 78, bottom: 77),
          child: const CircularProgressIndicator(),
        ),
      ),
      error: (error, _) {
        final isConnectivityError = error.toString().contains('no connection');
        return Center(
          child: Container(
            margin: const EdgeInsets.only(top: 49, bottom: 48),
            child: isConnectivityError
                ? const ConnectToInternet()
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    iconSize: 40,
                    onPressed: () {
                      ref.invalidate(malfuzatAudioPlayerProvider(source));
                    },
                  ),
          ),
        );
      },
      data: (updatedPlayer) {
        return _StatefulMalfuzatAudioPlayer(player: updatedPlayer);
      },
    );
  }
}

class _StatefulMalfuzatAudioPlayer extends ConsumerStatefulWidget {
  const _StatefulMalfuzatAudioPlayer({required this.player});

  final AudioPlayer player;

  @override
  ConsumerState<_StatefulMalfuzatAudioPlayer> createState() =>
      _StatefulMalfuzatAudioPlayerState();
}

class _StatefulMalfuzatAudioPlayerState
    extends ConsumerState<_StatefulMalfuzatAudioPlayer> {
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
          EasyDebounce.debounce('malfuzat-player-idle', const Duration(seconds: 10), () {
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
  void dispose() {
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playbackEventSubscription?.cancel();
    super.dispose();
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'player.dart';

final bismillahPlayerProvider = FutureProvider.autoDispose((ref) async {
  final AudioPlayer player = ref.read(playerProvider);

  var audioSource = AudioSource.asset(
    'assets/audios/0.mp3',
    tag: const MediaItem(
      id: 'bismillah',
      album: 'Quran',
      title: 'Bismillah',
    ),
  );

  await player.setAudioSource(audioSource);

  player.play();

  return player;
});

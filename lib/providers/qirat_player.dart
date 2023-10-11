import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final qiratPlayerProvider =
    FutureProvider.autoDispose.family((ref, String audioSrc) async {
  final AudioPlayer player = AudioPlayer();
  await player.setUrl(audioSrc);
  return player;
});

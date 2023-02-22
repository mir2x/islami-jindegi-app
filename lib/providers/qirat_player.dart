import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final qiratPlayerProvider =
    FutureProvider.autoDispose.family((ref, String audioSrc) async {
  final AudioPlayer player = AudioPlayer(playerId: audioSrc);
  await player.setSourceUrl(audioSrc);
  return player;
});

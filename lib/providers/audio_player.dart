import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final audioPlayerProvider =
    FutureProvider.autoDispose.family((ref, String audioSrc) async {
  final AudioPlayer player = AudioPlayer(playerId: 'unique_player_id');
  await player.setSourceUrl(audioSrc);
  return player;
});

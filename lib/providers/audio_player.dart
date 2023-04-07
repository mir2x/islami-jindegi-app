import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:native_app/objects/audio_source.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'local_file.dart';

final audioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioSource audioSource) async {
  AudioPlayer player;
  player = AudioPlayer(playerId: audioSource.id);

  var localFile = await ref.read(localFileProvider(audioSource.id).future);

  if (localFile != null) {
    await player.setSourceDeviceFile(localFile.path);
    return player;
  }

  String url = fileSrcUrl({
    'id': audioSource.id,
    'storage': audioSource.storage,
  });

  await player.setSourceUrl(url);

  return player;
});

final localAudioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioSource audioSource) async {
  AudioPlayer player;
  player = AudioPlayer(playerId: audioSource.id);

  var localFile = await ref.read(localFileProvider(audioSource.id).future);

  if (localFile != null) {
    await player.setSourceDeviceFile(localFile.path);
    return player;
  }

  return null;
});

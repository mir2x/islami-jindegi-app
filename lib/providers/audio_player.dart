import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:native_app/objects/audio_resource.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'local_file.dart';

final audioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioResource audioResource) async {
  final AudioPlayer player = AudioPlayer();

  var localFile = await ref.read(localFileProvider(audioResource.id).future);

  if (localFile != null) {
    await player.setFilePath(localFile.path);
    return player;
  }

  String url = fileSrcUrl({
    'id': audioResource.id,
    'storage': audioResource.storage,
  });

  await player.setUrl(url);

  return player;
});

final localAudioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioResource audioResource) async {
  AudioPlayer player = AudioPlayer();

  var localFile = await ref.read(localFileProvider(audioResource.id).future);

  if (localFile != null) {
    await player.setFilePath(localFile.path);
    return player;
  }

  return null;
});

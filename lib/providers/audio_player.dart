import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:native_app/objects/audio_source.dart';
import 'package:native_app/helpers/audio_utils.dart';

final audioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioSource audioSource) async {
  AudioPlayer player;
  player = AudioPlayer(playerId: audioSource.id);

  var downloadDir = await getExternalStorageDirectory();

  if (downloadDir != null) {
    final localFile = File(p.join(downloadDir.path, audioSource.id));

    if (await localFile.exists()) {
      await player.setSourceDeviceFile(localFile.path);
      return player;
    }
  }

  String url = audioSrc({'id': audioSource.id, 'storage': audioSource.storage});
  await player.setSourceUrl(url);

  return player;
});

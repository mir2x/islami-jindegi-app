import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/objects/audio_resource.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'local_file.dart';

final audioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioResource audioResource) async {
  final AudioPlayer player = AudioPlayer();

  var localFile = await ref.watch(localFileProvider(audioResource.id).future);

  if (localFile != null) {
    await player.setFilePath(localFile.path);
  } else {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      String url = fileSrcUrl({
        'id': audioResource.id,
        'storage': audioResource.storage,
      });

      await player.setUrl(url);
    } else {
      throw Exception('no connection');
    }
  }

  return player;
});

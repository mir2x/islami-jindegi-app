import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/objects/audio_resource.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'player.dart';
import 'local_file.dart';

final audioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioResource audioResource) async {
  final AudioPlayer player = ref.read(playerProvider);

  String filePath = fileTitlePath(audioResource.title, audioResource.id);
  var localFile = await ref.watch(localFileProvider(filePath).future);

  if (localFile != null) {
    var audioSource = AudioSource.file(
      localFile.path,
      tag: MediaItem(
        id: audioResource.id,
        album: audioResource.album,
        title: audioResource.title,
      ),
    );

    await player.stop();
    await player.setAudioSource(audioSource);
  } else {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      String url = fileSrcUrl({
        'id': audioResource.id,
        'storage': audioResource.storage,
      });

      var audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: audioResource.id,
          album: audioResource.album,
          title: audioResource.title,
        ),
      );

      await player.stop();
      await player.setAudioSource(audioSource);
    } else {
      throw Exception('no connection');
    }
  }

  return player;
});

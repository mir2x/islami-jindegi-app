import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/value_provider.dart';
import 'package:just_audio/just_audio.dart';
/* import 'package:just_audio_background/just_audio_background.dart'; */
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/objects/audio_resource.dart';
import 'package:native_app/helpers/file_title_path.dart';
import 'package:native_app/helpers/file_utils.dart';
import 'player.dart';
import 'local_file.dart';

// Tracks which audio resource currently "owns" the shared player.
// Used to prevent a disposing provider from stopping audio that the
// next provider has already set up.
final _currentAudioIdProvider = valueProvider<String?>(null);

final audioPlayerProvider =
    FutureProvider.autoDispose.family((ref, AudioResource audioResource) async {
  final AudioPlayer player = ref.read(playerProvider);

  ref.onDispose(() async {
    // Only stop the player if we still own it (i.e. no newer audio has
    // taken over). This prevents the old bayan's dispose from silencing
    // audio that the next bayan already configured.
    if (ref.read(_currentAudioIdProvider) == audioResource.id) {
      await player.stop();
    }
  });

  String filePath = fileTitlePath(audioResource.title, audioResource.id);
  var localFile = await ref.read(localFileProvider(filePath).future);

  // Claim ownership after the first await (outside the build phase),
  // still before stop()/setAudioSource() so the race condition is avoided.
  ref.read(_currentAudioIdProvider.notifier).set(audioResource.id);

  if (localFile != null) {
    var audioSource = AudioSource.file(
      localFile.path,
      /* tag: MediaItem( */
      /*   id: audioResource.id, */
      /*   album: audioResource.album, */
      /*   title: audioResource.title, */
      /* ), */
    );

    await player.stop();
    await player.setAudioSource(audioSource);
  } else {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      String url = fileSrcUrl({
        'id': audioResource.id,
        'storage': audioResource.storage,
      });

      var audioSource = AudioSource.uri(
        Uri.parse(url),
        /* tag: MediaItem( */
        /*   id: audioResource.id, */
        /*   album: audioResource.album, */
        /*   title: audioResource.title, */
        /* ), */
      );

      await player.stop();
      await player.setAudioSource(audioSource);
    } else {
      throw Exception('no connection');
    }
  }

  return player;
});

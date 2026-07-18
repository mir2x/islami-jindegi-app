import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/value_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/player.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/helpers/file_title_path.dart';

/// Bayan-local equivalent of `native_app/providers/audio_player.dart`.
///
/// The shared `audioPlayerProvider`/`AudioResource` pair is hard-wired to the
/// legacy JSON:API Shrine attachment shape (`{id, storage, metadata}` +
/// `fileSrcUrl`) and is still used by the not-yet-migrated dua module, so it
/// must not change. The .NET API instead gives bayan a flat, already-absolute
/// `audioUrl` string, so this provider plays that URL directly instead of
/// reconstructing a CDN URL from `storage`/`id` parts.
///
/// Local-file-first behaviour is preserved: it checks the same
/// `bayans/<id>`-keyed cache path that the download flow writes to via
/// `fileTitlePath`, so a downloaded bayan is played from disk instead of
/// streamed.
final _currentBayanAudioIdProvider = valueProvider<String?>(null);

final bayanAudioPlayerProvider = FutureProvider.autoDispose
    .family<AudioPlayer, ({String bayanId, String title, String audioUrl})>(
        (ref, params) async {
  final AudioPlayer player = ref.read(playerProvider);

  ref.onDispose(() async {
    // Only stop the player if we still own it — prevents a disposing
    // provider from silencing audio that a newer bayan already configured.
    if (ref.read(_currentBayanAudioIdProvider) == params.bayanId) {
      await player.stop();
    }
  });

  final filePath = fileTitlePath(params.title, 'bayans/${params.bayanId}');
  final localFile = await ref.read(localFileProvider(filePath).future);

  ref.read(_currentBayanAudioIdProvider.notifier).set(params.bayanId);

  if (localFile != null) {
    await player.stop();
    await player.setAudioSource(AudioSource.file(localFile.path));
  } else {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      await player.stop();
      await player.setAudioSource(AudioSource.uri(Uri.parse(params.audioUrl)));
    } else {
      throw Exception('no connection');
    }
  }

  return player;
});

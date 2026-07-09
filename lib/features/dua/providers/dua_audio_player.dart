import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/providers/player.dart';
import 'package:native_app/providers/local_file.dart';
import 'package:native_app/helpers/file_title_path.dart';

/// Dua-local equivalent of `native_app/providers/audio_player.dart`.
///
/// The shared `audioPlayerProvider`/`AudioResource` pair is hard-wired to the
/// legacy JSON:API Shrine attachment shape (`{id, storage, metadata}` +
/// `fileSrcUrl`) and is still used by the not-yet-migrated bayan module (and
/// still-shared malfuzat-style forks), so it must not change. The .NET API
/// instead gives dua a flat, already-absolute `audioUrl` string, so this
/// provider plays that URL directly instead of reconstructing a CDN URL from
/// `storage`/`id` parts.
///
/// Local-file-first behaviour is preserved: it checks the same
/// `duas/<id>`-keyed cache path that the download flow writes to via
/// `fileTitlePath`, so a downloaded dua is played from disk instead of
/// streamed.
final _currentDuaAudioIdProvider = StateProvider<String?>((ref) => null);

final duaAudioPlayerProvider = FutureProvider.autoDispose
    .family<AudioPlayer, ({String duaId, String title, String audioUrl})>(
        (ref, params) async {
  final AudioPlayer player = ref.read(playerProvider);

  ref.onDispose(() async {
    // Only stop the player if we still own it — prevents a disposing
    // provider from silencing audio that a newer dua already configured.
    if (ref.read(_currentDuaAudioIdProvider) == params.duaId) {
      await player.stop();
    }
  });

  final filePath = fileTitlePath(params.title, 'duas/${params.duaId}');
  final localFile = await ref.read(localFileProvider(filePath).future);

  ref.read(_currentDuaAudioIdProvider.notifier).state = params.duaId;

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

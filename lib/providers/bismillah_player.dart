import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
/* import 'package:just_audio_background/just_audio_background.dart'; */
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:native_app/objects/download_params.dart';
import 'player.dart';
import 'local_file.dart';
import 'connectivity_result.dart';
import 'downloader.dart';

final bismillahPlayerProvider =
    FutureProvider.autoDispose.family((ref, String nextAudioPath) async {
  final AudioPlayer player = ref.read(playerProvider);
  String staticHostName = dotenv.env['STATIC_HOST_NAME']!;

  String nextFileUrl = '$staticHostName/assets/al-quran/qirats/$nextAudioPath';
  String nextFilePath = 'al-quran/qirats/$nextAudioPath';

  var nextFileProvider = localFileProvider(nextFilePath);
  var nextLocalFile = await ref.watch(nextFileProvider.future);

  if (nextLocalFile == null) {
    var connectivityResult = await ref.watch(connectivityResultProvider.future);

    if (connectivityResult != ConnectivityResult.none) {
      var params = DownloadParams(
        url: nextFileUrl,
        savePath: nextFilePath,
      );

      ref.watch(downloaderProvider(params).future);
    }
  }

  var audioSource = AudioSource.asset(
    'assets/audios/0.mp3',
    /* tag: const MediaItem( */
    /*   id: 'bismillah', */
    /*   album: 'Quran', */
    /*   title: 'Bismillah', */
    /* ), */
  );

  await player.setAudioSource(audioSource);

  player.play();

  return player;
});

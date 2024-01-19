import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:native_app/objects/qirat_player_audio.dart';
import 'package:native_app/objects/download_params.dart';
import 'local_file.dart';
import 'connectivity_result.dart';
import 'downloader.dart';

final qiratPlayerProvider =
    FutureProvider.autoDispose.family((ref, QiratPlayerAudio qirat) async {
  String staticHostName = dotenv.env['STATIC_HOST_NAME']!;
  String fileUrl = '$staticHostName/assets/al-quran/qirats/${qirat.audioPath}';
  String filePath = 'al-quran/qirats/${qirat.audioPath}';

  var fileProvider = localFileProvider(filePath);
  var localFile = await ref.watch(fileProvider.future);

  if (localFile == null) {
    var connectivityResult = await ref.watch(connectivityResultProvider.future);

    if (connectivityResult != ConnectivityResult.none) {
      var params = DownloadParams(
        url: fileUrl,
        savePath: filePath,
      );

      Response? response = await ref.watch(
        downloaderProvider(params).future,
      );

      if (response != null && response.statusCode == 200) {
        await ref.read(fileProvider.notifier).check(filePath);
        localFile = await ref.watch(fileProvider.future);
      } else {
        throw Exception('download error');
      }
    } else {
      throw Exception('no connection');
    }
  }

  if (localFile != null) {
    var audioSource = AudioSource.file(
      localFile.path,
      tag: MediaItem(
        id: qirat.audioPath,
        album: qirat.surah,
        title: qirat.ayah,
      ),
    );

    await qirat.player.setAudioSource(audioSource);
    qirat.player.play();
  } else {
    throw Exception('no file');
  }

  return qirat.player;
});

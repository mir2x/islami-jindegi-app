import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'local_file.dart';
import 'downloader.dart';
import 'package:native_app/objects/download_params.dart';

final qiratPlayerProvider =
    FutureProvider.autoDispose.family((ref, String audioPath) async {
  String staticHostName = dotenv.env['STATIC_HOST_NAME']!;
  String fileUrl = '$staticHostName/assets/al-quran/qirats/$audioPath';
  String filePath = 'al-quran/qirats/$audioPath';

  var fileProvider = localFileProvider(filePath);
  var localFile = await ref.watch(fileProvider.future);

  if (localFile == null) {
    var params = DownloadParams(
      url: fileUrl,
      savePath: filePath,
    );

    Response? response = await ref.watch(
      downloaderProvider(params).future,
    );

    if (response != null && response.statusCode == 200) {
      await ref.read(fileProvider.notifier).check(filePath);
    }

    localFile = await ref.watch(fileProvider.future);
  }

  final AudioPlayer player = AudioPlayer();

  if (localFile != null) {
    await player.setFilePath(localFile.path);
  }

  return player;
});

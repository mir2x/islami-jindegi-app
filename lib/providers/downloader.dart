import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/download_params.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

final downloaderProvider = FutureProvider.autoDispose
    .family<Response?, DownloadParams>((ref, DownloadParams params) async {
  var dir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  if (dir == null) return null;

  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  Response? response;

  try {
    response = await Dio().download(
      params.url,
      '${dir.path}/${params.savePath}',
      cancelToken: cancelToken,
      onReceiveProgress: (int received, int total) {
        if (total != -1) {
          params.downloadProgress.update(received / total);
        }
      },
    );
  } on DioException catch (e) {
    if (CancelToken.isCancel(e)) {}
    return null;
  }

  return response;
});

import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/objects/download_params.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'local_file.dart';
import 'check_downloaded_file.dart';

final downloaderProvider = FutureProvider.autoDispose
    .family<Response?, DownloadParams>((ref, DownloadParams params) async {
  var dir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  if (dir == null) return null;

  ref.onDispose(() => params.cancelToken.cancel());

  Response? response;

  try {
    response = await Dio().download(
      params.url,
      '${dir.path}/${params.savePath}',
      cancelToken: params.cancelToken,
      onReceiveProgress: (int received, int total) {
        if (total != -1) {
          params.downloadProgress.update({
            'received': received,
            'total': total,
          });
        }
      },
    );
  } on DioException catch (e) {
    if (CancelToken.isCancel(e)) {
      var localFile = await ref.watch(
        localFileProvider(params.savePath).future,
      );

      if (localFile != null) {
        await localFile.delete();
        await ref
            .read(checkDownloadedFileProvider(params.savePath).notifier)
            .check(params.savePath);
      }

      return Response(
        requestOptions: RequestOptions(),
        statusCode: 408,
        statusMessage: 'Request cancelled',
      );
    } else {
      return null;
    }
  }

  return response;
});

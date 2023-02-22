import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class Downloader {
  Future<void> download({required String url, required String savePath}) async {
    // requests permission for downloading the file
    var result = await Permission.storage.request();
    if (result != PermissionStatus.granted) {
      if (await Permission.speech.isPermanentlyDenied) {
        openAppSettings();
      }

      return;
    }

    var dir = await getExternalStorageDirectory();

    if (dir != null) {
      Dio dio = Dio();
      await dio.download(url, '${dir.path}/$savePath');
    }
  }
}

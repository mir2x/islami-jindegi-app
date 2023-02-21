import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class Downloader {
  Future<void> download({required String url, required String savePath}) async {
    // requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    var dir = await getExternalStorageDirectory();

    if (dir != null) {
      Dio dio = Dio();
      await dio.download(url, '${dir.path}/$savePath');
    }
  }

  Future<bool> _requestWritePermission() async {
    var result = await Permission.storage.request();
    return result == PermissionStatus.granted;
  }
}

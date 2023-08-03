import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class Downloader {
  final progressNotifier = ValueNotifier<double>(0);

  Future<dynamic> download({
    required String url,
    required String savePath,
  }) async {
    // requests permission for downloading the file
    var result = await Permission.storage.request();
    if (result != PermissionStatus.granted) {
      if (result == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }

      return;
    }

    var dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    if (dir != null) {
      Dio dio = Dio();
      return await dio.download(
        url,
        '${dir.path}/$savePath',
        onReceiveProgress: (int count, int total) {
          if (total != -1) {
            progressNotifier.value = count / total;
          }
        },
      );
    }
  }
}

import 'dart:io' show File, Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

final localFileProvider =
    FutureProvider.autoDispose.family((ref, String path) async {
  var downloadDir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  if (downloadDir != null) {
    var localFile = File(p.join(downloadDir.path, path));

    if (await localFile.exists()) {
      return localFile;
    }
  }

  return null;
});

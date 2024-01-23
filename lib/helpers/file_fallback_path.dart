import 'dart:io' show File, Platform;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String?> fileFallbackPath(String path) async {
  var downloadDir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  if (downloadDir != null) {
    var localFile = File(p.join(downloadDir.path, path));

    if (await localFile.exists()) {
      return path;
    }

    if (path.contains('_')) {
      List<String> parts = path.split('/');
      parts[1] = parts[1].split('_').last;
      String alternatePath = parts.join('/');

      var alternativeFile = File(p.join(downloadDir.path, alternatePath));

      if (await alternativeFile.exists()) {
        return alternatePath;
      }
    }
  }

  return null;
}

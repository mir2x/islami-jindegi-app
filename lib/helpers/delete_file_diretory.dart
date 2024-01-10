import 'dart:io' show Platform, Directory;
import 'package:path_provider/path_provider.dart';

Future deleteFileDirectory(String filePath) async {
  var downloadDir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  if (downloadDir != null) {
    String dirPath =
        '${downloadDir.path}/${filePath.split('/').sublist(0, 2).join('/')}';
    await Directory(dirPath).delete(recursive: true);
  }
}

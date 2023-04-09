import 'dart:io' show File, Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class LocalFileNotifier extends AutoDisposeFamilyAsyncNotifier<File?, String> {
  @override
  Future<File?> build(String arg) async {
    return _getFile(arg);
  }

  Future<void> check(String arg) async {
    state = AsyncValue.data(await _getFile(arg));
  }

  Future<File?> _getFile(String path) async {
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
  }
}

final localFileProvider =
    AsyncNotifierProvider.autoDispose.family<LocalFileNotifier, File?, String>(
  LocalFileNotifier.new,
);

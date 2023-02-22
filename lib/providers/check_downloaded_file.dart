import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CheckDownloadedFileNotifier extends FamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String arg) async {
    return _checkFile(arg);
  }

  Future<void> check(String arg) async {
    state = AsyncValue.data(await _checkFile(arg));
  }

  Future<bool> _checkFile(String path) async {
    var downloadDir = await getExternalStorageDirectory();
    bool result;

    if (downloadDir != null) {
      final localFile = File(p.join(downloadDir.path, path));
      result = await localFile.exists();
    } else {
      result = false;
    }

    return Future.value(result);
  }
}

final checkDownloadedFileProvider =
    AsyncNotifierProvider.family<CheckDownloadedFileNotifier, bool, String>(
  CheckDownloadedFileNotifier.new,
);

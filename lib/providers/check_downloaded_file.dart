import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_file.dart';

class CheckDownloadedFileNotifier extends FamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String arg) async {
    return _checkFile(arg);
  }

  Future<void> check(String arg) async {
    state = AsyncValue.data(await _checkFile(arg));
  }

  Future<bool> _checkFile(String path) async {
    var localFile = await ref.read(localFileProvider(path).future);
    return localFile != null;
  }
}

final checkDownloadedFileProvider =
    AsyncNotifierProvider.family<CheckDownloadedFileNotifier, bool, String>(
  CheckDownloadedFileNotifier.new,
);

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_file.dart';

class CheckDownloadedFileNotifier
    extends AutoDisposeFamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String arg) async {
    // Keep the provider alive to prevent auto-dispose during widget tree changes
    ref.keepAlive();

    debugPrint('[CheckDownloadedFileNotifier] build called for: $arg');
    return _checkFile(arg);
  }

  Future<void> check(String path) async {
    await ref.read(localFileProvider(path).notifier).check(path);
    state = AsyncValue.data(await _checkFile(path));
  }

  Future<bool> _checkFile(String path) async {
    var localFile = await ref.read(localFileProvider(path).future);
    return localFile != null;
  }
}

final checkDownloadedFileProvider = AsyncNotifierProvider.autoDispose
    .family<CheckDownloadedFileNotifier, bool, String>(
  CheckDownloadedFileNotifier.new,
);

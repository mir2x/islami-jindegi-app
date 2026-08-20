import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Filesystem locations for offline media cached alongside the SQLite content.
///
/// The documents directory is resolved *at every call* rather than being
/// stored: on iOS the app container is re-created with a new UUID on update,
/// so any absolute path persisted to the database goes stale the next time
/// the user updates the app. Rows therefore store a bare file name and this
/// resolves it against wherever the container lives right now.
class OfflineStorage {
  static Future<Directory> imagesDir(String feature) async {
    final dir = Directory(
      p.join(
        (await getApplicationDocumentsDirectory()).path,
        'offline_images',
        feature,
      ),
    );
    await dir.create(recursive: true);
    return dir;
  }

  static Future<String> imagesDirPath(String feature) async =>
      (await imagesDir(feature)).path;

  /// Root of every feature's cached media, for a wholesale wipe.
  static Future<Directory> imagesRoot() async => Directory(
        p.join(
          (await getApplicationDocumentsDirectory()).path,
          'offline_images',
        ),
      );

  /// Absolute path for a [fileName] stored in the database, or null when the
  /// row has no cached file. Absolute values are passed through unchanged so
  /// a row written by an older build still resolves.
  static String? resolve(String? fileName, String? dirPath) {
    if (fileName == null || fileName.isEmpty) return null;
    if (p.isAbsolute(fileName)) return fileName;
    if (dirPath == null) return null;
    return p.join(dirPath, fileName);
  }
}

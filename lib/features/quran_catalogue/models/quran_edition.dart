import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../downloader/providers/download_providers.dart';

class QuranEdition {
  final String id;
  final String title;
  final String coverImagePath;
  final int sizeBytes;
  final int imageWidth;
  final int imageHeight;
  final String imageExt;
  final bool isDownloaded;

  const QuranEdition({
    required this.id,
    required this.title,
    required this.coverImagePath,
    required this.sizeBytes,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageExt,
    this.isDownloaded = false,
  });

  QuranEdition copyWith({
    bool? isDownloaded,
  }) {
    return QuranEdition(
      id: id,
      title: title,
      coverImagePath: coverImagePath,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      imageExt: imageExt,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      sizeBytes: sizeBytes,
    );
  }

  static Future<bool> validateDownload(String editionId, String ext) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final editionDir = Directory('${dir.path}/$editionId');

      if (!await editionDir.exists()) {
        await _clearDownloadStatus(editionId);
        return false;
      }

      final files = await editionDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.$ext'))
          .length;

      if (files < 600) {
        print("Quran edition $editionId has only $files pages (expected ~604)");
        await _clearDownloadStatus(editionId);
        try {
          await editionDir.delete(recursive: true);
        } catch (_) {}
        return false;
      }

      return true;
    } catch (e) {
      print("Error validating Quran edition $editionId: $e");
      await _clearDownloadStatus(editionId);
      return false;
    }
  }

  static Future<void> _clearDownloadStatus(String editionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reciter_downloaded_$editionId');
  }

  static Future<QuranEdition> fromMap(Map<String, dynamic> map) async {
    var downloaded = await isAssetDownloaded(map['id']);

    if (downloaded) {
      downloaded = await validateDownload(map['id'], map['ext']);
    }

    return QuranEdition(
      id: map['id'],
      title: map['title'],
      coverImagePath: map['cover'],
      sizeBytes: map['sizeBytes'],
      imageWidth: map['width'],
      imageHeight: map['height'],
      imageExt: map['ext'],
      isDownloaded: downloaded,
    );
  }
}

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../downloader/viewmodel/download_providers.dart';

class QuranEdition {
  final String id;
  final String title;
  final String coverImagePath;
  final String url;
  final int sizeBytes;
  final int imageWidth;
  final int imageHeight;
  final String imageExt;
  final bool isDownloaded;

  const QuranEdition({
    required this.id,
    required this.title,
    required this.coverImagePath,
    required this.url,
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
      url: url,
      sizeBytes: sizeBytes,
    );
  }

  /// Validates that the Quran edition download is complete and not corrupted.
  /// Checks that the directory exists and contains the expected number of page files.
  static Future<bool> validateDownload(String editionId, String ext) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final editionDir = Directory('${dir.path}/$editionId');

      if (!await editionDir.exists()) {
        await _clearDownloadStatus(editionId);
        return false;
      }

      // Count the number of page files - Quran has 604 pages
      final files = await editionDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.$ext'))
          .length;

      // Quran has 604 pages, but we'll be lenient and check for at least 600
      // to account for any minor variations
      if (files < 600) {
        print("Quran edition $editionId has only $files pages (expected ~604)");
        await _clearDownloadStatus(editionId);
        // Delete the incomplete directory
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

  /// Clears the download status to allow re-downloading
  static Future<void> _clearDownloadStatus(String editionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reciter_downloaded_$editionId');
  }

  static Future<QuranEdition> fromMap(Map<String, dynamic> map) async {
    var downloaded = await isAssetDownloaded(map['id']);
    
    // Validate file integrity if marked as downloaded
    if (downloaded) {
      downloaded = await validateDownload(map['id'], map['ext']);
    }

    return QuranEdition(
      id: map['id'],
      title: map['title'],
      coverImagePath: map['cover'],
      url: map['url'],
      sizeBytes: map['sizeBytes'],
      imageWidth: map['width'],
      imageHeight: map['height'],
      imageExt: map['ext'],
      isDownloaded: downloaded,
    );
  }
}


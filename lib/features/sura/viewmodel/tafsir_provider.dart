import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../downloader/viewmodel/download_providers.dart';
import '../model/tafsir.dart';

class AyahIdentifier {
  final int sura;
  final int ayah;
  AyahIdentifier({required this.sura, required this.ayah});
  @override
  bool operator ==(Object other) =>
      other is AyahIdentifier && other.sura == sura && other.ayah == ayah;
  @override
  int get hashCode => sura.hashCode ^ ayah.hashCode;
}

class TafsirRepository {
  final List<Map<String, dynamic>> _availableTafsirsMetadata = [
    {
      'id': 'tafsir_taqi_usmani_bn',
      'title': 'তাফসীর (তাকী উসমানী)',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/tafsirs/tafsir_taqi_usmani_bn.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260201%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260201T085614Z&X-Amz-Expires=5184000&X-Amz-SignedHeaders=host&X-Amz-Signature=1434f6faaf56c8c70e5ae6697330a211de47ec8fc013200aaafb28f38da34f25',
      'sizeBytes': 4139520,
    },
    {
      'id': 'tafsir_ibn_kathir_bn',
      'title': 'তাফসীরে ইবনে কাছীর',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/tafsirs/tafsir_ibn_kathir_bn.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260201%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260201T085255Z&X-Amz-Expires=5184000&X-Amz-SignedHeaders=host&X-Amz-Signature=b1790d4d1904983eb8a3561abce912bd4df61f1f3c12cde0952c52a1fd7a4aad',
      'sizeBytes': 25267877,
    },
    {
      'id': 'tafsir_ibn_kathir_en',
      'title': 'তাফসীরে ইবনে কাছীর (ইংরেজি)',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/tafsirs/tafsir_ibn_kathir_en.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260201%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260201T085502Z&X-Amz-Expires=5184000&X-Amz-SignedHeaders=host&X-Amz-Signature=810d3c57ab710018d7a60afa0a86ce7cd07a7406ac84d91326d77f21435d0fd7',
      'sizeBytes': 37835638,
    },
    {
      'id': 'tafsir_maariful_quran_bn',
      'title': 'তাফসীরে মা\'আরিফুল কুরআন',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/tafsirs/tafsir_maariful_quran_bn.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260201%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260201T085531Z&X-Amz-Expires=5184000&X-Amz-SignedHeaders=host&X-Amz-Signature=c1aec6ee864ee1748bb1367749e19a4bb910e4eb54cc8ed62e0707645f7c7aa9',
      'sizeBytes': 208867480,
    },
    {
      'id': 'tafsir_maariful_quran_en',
      'title': 'তাফসীরে মা\'আরিফুল কুরআন (ইংরেজি)',
      'url':
          'https://t3.storage.dev/static.islamijindegi.com/assets/al-quran/tafsirs/tafsir_maariful_quran_en.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=tid_SVQEqpmkAvfcFleZgB_gQqyIZinQViMhmrBLpwlCLzNcowEneM%2F20260201%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260201T085553Z&X-Amz-Expires=5184000&X-Amz-SignedHeaders=host&X-Amz-Signature=86f87fe648fc448239e61c96b4f41e16259c270bcfd31ffc6689505fd7a42134',
      'sizeBytes': 20908482,
    },
  ];

  Future<String> getLocalTafsirPath(String sourceId) async {
    final docDir = await getApplicationDocumentsDirectory();
    return '${docDir.path}/tafsir/$sourceId.json';
  }

  /// Validates that the tafsir file exists and is valid JSON.
  /// If the file is corrupted, it clears the download flag and deletes the file.
  Future<bool> validateTafsirFile(String sourceId) async {
    try {
      final localPath = await getLocalTafsirPath(sourceId);
      final file = File(localPath);

      if (!await file.exists()) {
        // File doesn't exist, clear the download flag
        await clearDownloadStatus(sourceId);
        return false;
      }

      // Try to parse the file to validate it's proper JSON
      final jsonString = await file.readAsString();
      final decoded = jsonDecode(jsonString);
      
      // Basic validation: should be a non-empty list
      if (decoded is! List || decoded.isEmpty) {
        print("Tafsir file $sourceId is invalid (not a list or empty)");
        await clearDownloadStatus(sourceId);
        await file.delete();
        return false;
      }

      return true;
    } catch (e) {
      print("Error validating tafsir file $sourceId: $e");
      // File is corrupted, clear status and delete
      await clearDownloadStatus(sourceId);
      try {
        final localPath = await getLocalTafsirPath(sourceId);
        final file = File(localPath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
      return false;
    }
  }

  /// Clears the download status to allow re-downloading
  Future<void> clearDownloadStatus(String sourceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reciter_downloaded_$sourceId');
  }

  Future<String?> _getTafsirContentForAyah(
      String sourceId, int sura, int ayah) async {
    try {
      final localPath = await getLocalTafsirPath(sourceId);
      final file = File(localPath);

      if (!await file.exists()) {
        return null;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> allTafsirs = jsonDecode(jsonString);

      final tafsirData = allTafsirs.firstWhere(
        (item) => item['sura'] == sura && item['ayah'] == ayah,
        orElse: () => null,
      );

      return tafsirData != null
          ? tafsirData['tafsir']
          : "এই আয়াতের জন্য কোনো তাফসীর পাওয়া যায়নি।";
    } catch (e) {
      print("Error reading local tafsir for $sourceId: $e");
      return "তাফসীর ফাইলটি পড়তে সমস্যা হয়েছে।";
    }
  }

  Future<List<TafsirSource>> getAllTafsirsForAyah(int sura, int ayah) async {
    final List<Future<TafsirSource>> futureTafsirs =
        _availableTafsirsMetadata.map((meta) async {
      final id = meta['id'] as String;

      var isDownloaded = await isAssetDownloaded(id);
      String? content;

      // Validate file integrity if marked as downloaded
      if (isDownloaded) {
        isDownloaded = await validateTafsirFile(id);
      }

      if (isDownloaded) {
        content = await _getTafsirContentForAyah(id, sura, ayah);
      }

      return TafsirSource(
        id: id,
        title: meta['title'] as String,
        url: meta['url'] as String,
        sizeBytes: meta['sizeBytes'] as int,
        isDownloaded: isDownloaded,
        content: content,
      );
    }).toList();

    return await Future.wait(futureTafsirs);
  }
}

final tafsirRepositoryProvider =
    Provider<TafsirRepository>((ref) => TafsirRepository());

final tafsirProvider =
    FutureProvider.family<List<TafsirSource>, AyahIdentifier>(
        (ref, ayahIdentifier) {
  final repository = ref.watch(tafsirRepositoryProvider);
  return repository.getAllTafsirsForAyah(
      ayahIdentifier.sura, ayahIdentifier.ayah);
});

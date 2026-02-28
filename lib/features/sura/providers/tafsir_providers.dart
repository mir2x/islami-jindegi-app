import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../downloader/providers/download_providers.dart';
import '../models/tafsir_source.dart';

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
      'sizeBytes': 4139520,
    },
    {
      'id': 'tafsir_ibn_kathir_bn',
      'title': 'তাফসীরে ইবনে কাছীর',
      'sizeBytes': 25267877,
    },
    {
      'id': 'tafsir_ibn_kathir_en',
      'title': 'তাফসীরে ইবনে কাছীর (ইংরেজি)',
      'sizeBytes': 37835638,
    },
    {
      'id': 'tafsir_maariful_quran_bn',
      'title': 'তাফসীরে মা\'আরিফুল কুরআন',
      'sizeBytes': 208867480,
    },
    {
      'id': 'tafsir_maariful_quran_en',
      'title': 'তাফসীরে মা\'আরিফুল কুরআন (ইংরেজি)',
      'sizeBytes': 20908482,
    },
  ];

  Future<String> getLocalTafsirPath(String sourceId) async {
    final docDir = await getApplicationDocumentsDirectory();
    return '${docDir.path}/tafsir/$sourceId.json';
  }

  Future<bool> validateTafsirFile(String sourceId) async {
    try {
      final localPath = await getLocalTafsirPath(sourceId);
      final file = File(localPath);

      if (!await file.exists()) {
        await clearDownloadStatus(sourceId);
        return false;
      }

      final jsonString = await file.readAsString();
      final decoded = jsonDecode(jsonString);

      if (decoded is! List || decoded.isEmpty) {
        print("Tafsir file $sourceId is invalid (not a list or empty)");
        await clearDownloadStatus(sourceId);
        await file.delete();
        return false;
      }

      return true;
    } catch (e) {
      print("Error validating tafsir file $sourceId: $e");
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

      if (isDownloaded) {
        isDownloaded = await validateTafsirFile(id);
      }

      if (isDownloaded) {
        content = await _getTafsirContentForAyah(id, sura, ayah);
      }

      return TafsirSource(
        id: id,
        title: meta['title'] as String,
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

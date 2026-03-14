import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
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
  static const int _tafsirDbVersion = 1;
  static final Map<String, Future<bool>> _importTasks = {};

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

  Future<String> getLocalTafsirDbPath(String sourceId) async {
    final dbPath = await getDatabasesPath();
    return p.join(dbPath, 'tafsir_$sourceId.sqlite3');
  }

  String _dbVersionKey(String sourceId) => 'tafsir_db_version_$sourceId';

  Future<bool> _isTafsirDbReady(String sourceId) async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt(_dbVersionKey(sourceId)) ?? 0;
    if (storedVersion < _tafsirDbVersion) {
      return false;
    }

    final dbPath = await getLocalTafsirDbPath(sourceId);
    return databaseExists(dbPath);
  }

  Future<void> _clearLocalTafsirData(String sourceId) async {
    await clearDownloadStatus(sourceId);
    try {
      final jsonPath = await getLocalTafsirPath(sourceId);
      final jsonFile = File(jsonPath);
      if (await jsonFile.exists()) {
        await jsonFile.delete();
      }
    } catch (_) {}

    try {
      final dbPath = await getLocalTafsirDbPath(sourceId);
      if (await databaseExists(dbPath)) {
        await deleteDatabase(dbPath);
      }
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dbVersionKey(sourceId));
  }

  Future<bool> _importTafsirJsonToDb(String sourceId) async {
    final existingTask = _importTasks[sourceId];
    if (existingTask != null) {
      return existingTask;
    }

    final task = () async {
      try {
        final localJsonPath = await getLocalTafsirPath(sourceId);
        final jsonFile = File(localJsonPath);
        if (!await jsonFile.exists()) {
          return false;
        }

        final jsonString = await jsonFile.readAsString();
        final decoded = jsonDecode(jsonString);
        if (decoded is! List || decoded.isEmpty) {
          await _clearLocalTafsirData(sourceId);
          return false;
        }

        final dbPath = await getLocalTafsirDbPath(sourceId);
        if (await databaseExists(dbPath)) {
          await deleteDatabase(dbPath);
        }

        final db = await openDatabase(
          dbPath,
          version: _tafsirDbVersion,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE tafsir_entries (
                sura INTEGER NOT NULL,
                ayah INTEGER NOT NULL,
                tafsir TEXT NOT NULL,
                PRIMARY KEY (sura, ayah)
              )
            ''');
            await db.execute(
              'CREATE INDEX idx_tafsir_sura_ayah ON tafsir_entries (sura, ayah)',
            );
          },
        );

        try {
          await db.transaction((txn) async {
            Batch batch = txn.batch();
            int pending = 0;

            for (final item in decoded) {
              if (item is! Map<String, dynamic>) {
                continue;
              }
              batch.insert(
                'tafsir_entries',
                {
                  'sura': item['sura'],
                  'ayah': item['ayah'],
                  'tafsir': item['tafsir'] ?? '',
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
              pending++;

              if (pending >= 500) {
                await batch.commit(noResult: true);
                batch = txn.batch();
                pending = 0;
              }
            }

            if (pending > 0) {
              await batch.commit(noResult: true);
            }
          });
        } finally {
          await db.close();
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_dbVersionKey(sourceId), _tafsirDbVersion);

        // Drop the huge JSON file after successful import to save storage.
        if (await jsonFile.exists()) {
          await jsonFile.delete();
        }

        return true;
      } catch (_) {
        await _clearLocalTafsirData(sourceId);
        return false;
      } finally {
        _importTasks.remove(sourceId);
      }
    }();

    _importTasks[sourceId] = task;
    return task;
  }

  Future<bool> ensureTafsirReady(String sourceId) async {
    if (await _isTafsirDbReady(sourceId)) {
      return true;
    }

    final jsonPath = await getLocalTafsirPath(sourceId);
    if (await File(jsonPath).exists()) {
      return _importTafsirJsonToDb(sourceId);
    }

    return false;
  }

  Future<bool> validateTafsirFile(String sourceId) async {
    try {
      return ensureTafsirReady(sourceId);
    } catch (_) {
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
      if (!await ensureTafsirReady(sourceId)) {
        return null;
      }

      final dbPath = await getLocalTafsirDbPath(sourceId);
      final db = await openDatabase(dbPath, readOnly: true);
      try {
        final rows = await db.query(
          'tafsir_entries',
          columns: ['tafsir'],
          where: 'sura = ? AND ayah = ?',
          whereArgs: [sura, ayah],
          limit: 1,
        );

        if (rows.isEmpty) {
          return "এই আয়াতের জন্য কোনো তাফসীর পাওয়া যায়নি।";
        }

        return rows.first['tafsir'] as String?;
      } finally {
        await db.close();
      }
    } catch (_) {
      return "তাফসীর ফাইলটি পড়তে সমস্যা হয়েছে।";
    }
  }

  Future<List<TafsirSource>> getAllTafsirsForAyah(int sura, int ayah) async {
    final List<TafsirSource> results = [];
    for (final meta in _availableTafsirsMetadata) {
      final id = meta['id'] as String;

      var isDownloaded = await isAssetDownloaded(id);
      String? content;

      if (isDownloaded) {
        isDownloaded = await validateTafsirFile(id);
      }

      if (isDownloaded) {
        content = await _getTafsirContentForAyah(id, sura, ayah);
      }

      results.add(TafsirSource(
        id: id,
        title: meta['title'] as String,
        sizeBytes: meta['sizeBytes'] as int,
        isDownloaded: isDownloaded,
        content: content,
      ));
    }

    return results;
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

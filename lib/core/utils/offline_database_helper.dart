import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Opens the bundled `offline_data_15.sqlite3` asset for read-only access.
/// Similar to [DatabaseHelper] but targets the offline content database
/// instead of the quran database.
class OfflineDatabaseHelper {
  static Database? _database;
  static const int _dataVersion = 15;
  static const String _dbFileName = 'offline_data_$_dataVersion.sqlite3';
  static const String _dbVersionKey = 'offline_data_db_version';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbFileName);
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt(_dbVersionKey) ?? 0;

    final exists = await databaseExists(path);
    final needsUpdate = !exists || storedVersion < _dataVersion;

    if (needsUpdate) {
      // Close existing database if open
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // Delete old database if exists
      if (exists) {
        await deleteDatabase(path);
      }

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load('assets/db/$_dbFileName');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);

      // Store the new version
      await prefs.setInt(_dbVersionKey, _dataVersion);
    }

    return await openDatabase(path, readOnly: true);
  }
}

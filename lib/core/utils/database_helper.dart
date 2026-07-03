import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'quran.db';
  // Increment this version when the database content changes
  static const int _dbVersion = 4;
  static const String _dbVersionKey = 'quran_db_version';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt(_dbVersionKey) ?? 0;

    final exists = await databaseExists(path);
    final needsUpdate = !exists || storedVersion < _dbVersion;

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

      ByteData data = await rootBundle.load(join('assets', _dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);

      // Store the new version
      await prefs.setInt(_dbVersionKey, _dbVersion);
    }

    return await openDatabase(path, readOnly: true);
  }
}

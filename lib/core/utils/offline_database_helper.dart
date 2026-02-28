import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Opens a per-feature SQLite database for read-only access.
/// The database must already be downloaded locally.
///
/// Usage:
///   final helper = OfflineDatabaseHelper(feature: 'articles', version: 1);
///   final db = await helper.database;
class OfflineDatabaseHelper {
  static final Map<String, Database> _cache = {};

  final String feature;
  final int version;

  OfflineDatabaseHelper({required this.feature, required this.version});

  String get _dbFileName => '${feature}.sqlite3';
  String get _prefKey => 'offline_db_version_$feature';

  /// Check if the DB file exists locally (has been downloaded).
  static Future<bool> isAvailable(String feature) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, '${feature}.sqlite3');
    return await databaseExists(path);
  }

  /// Get the local file path for a feature's database.
  static Future<String> getDbPath(String feature) async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, '${feature}.sqlite3');
  }

  Future<Database> get database async {
    if (_cache.containsKey(feature)) return _cache[feature]!;
    _cache[feature] = await _initDB();
    return _cache[feature]!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbFileName);

    final exists = await databaseExists(path);
    if (!exists) {
      throw Exception(
          'Database "$feature" not available locally. Download it first.');
    }

    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt(_prefKey) ?? 0;

    if (storedVersion < version) {
      if (_cache[feature] != null) {
        await _cache[feature]!.close();
        _cache.remove(feature);
      }
      await deleteDatabase(path);
      throw Exception(
          'Database "$feature" needs version update. Please re-download.');
    }

    return await openDatabase(path, readOnly: true);
  }

  /// Mark a feature DB as downloaded with its version.
  static Future<void> markVersion(String feature, int version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('offline_db_version_$feature', version);
  }

  /// Call this to force-close and evict a feature's DB from cache.
  static Future<void> evict(String feature) async {
    final db = _cache.remove(feature);
    await db?.close();
  }
}

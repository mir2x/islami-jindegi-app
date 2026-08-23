import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// CREATE TABLE statements per offline feature. This is the single source of
/// truth for local schema — previously these tables only ever existed inside
/// prebuilt `.sqlite3` files downloaded from a static bucket, so no DDL lived
/// in the app at all. Now that content is synced incrementally from the
/// admin-curated `/{domain}/offline-sync` endpoints, the app owns its own
/// schema and creates it on first open.
const Map<String, List<String>> _schemas = {
  'books': [
    '''CREATE TABLE books (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      excerpt TEXT,
      publisher TEXT,
      price TEXT,
      language TEXT,
      cover_url TEXT,
      document_url TEXT,
      position INTEGER,
      published INTEGER,
      published_at TEXT,
      cover_image_path TEXT,
      created_at TEXT,
      updated_at TEXT
    )''',
    '''CREATE TABLE chapters (
      id TEXT PRIMARY KEY,
      book_id TEXT,
      title TEXT NOT NULL,
      body TEXT,
      position INTEGER,
      reading_order INTEGER
    )''',
    '''CREATE TABLE subchapters (
      id TEXT PRIMARY KEY,
      chapter_id TEXT,
      title TEXT NOT NULL,
      body TEXT,
      position INTEGER,
      parent_subchapter_id TEXT,
      reading_order INTEGER
    )''',
    '''CREATE TABLE authors (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      info TEXT,
      position INTEGER
    )''',
    '''CREATE TABLE books_authors (
      book_id TEXT NOT NULL,
      author_id TEXT NOT NULL,
      PRIMARY KEY (book_id, author_id)
    )''',
    'CREATE INDEX idx_chapters_book_id ON chapters(book_id)',
    'CREATE INDEX idx_chapters_book_reading_order ON chapters(book_id, reading_order)',
    'CREATE INDEX idx_subchapters_chapter_id ON subchapters(chapter_id)',
    'CREATE INDEX idx_subchapters_reading_order ON subchapters(reading_order)',
    'CREATE INDEX idx_books_navigation ON books(published, position, id)',
  ],
  'duas': [
    '''CREATE TABLE duas (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      body TEXT,
      excerpt TEXT,
      language TEXT,
      audio_url TEXT,
      document_url TEXT,
      published INTEGER,
      position INTEGER,
      created_at TEXT,
      updated_at TEXT
    )''',
    '''CREATE TABLE dua_categories (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      position INTEGER
    )''',
    '''CREATE TABLE dua_categorizations (
      dua_id TEXT NOT NULL,
      dua_category_id TEXT NOT NULL,
      PRIMARY KEY (dua_id, dua_category_id)
    )''',
    'CREATE INDEX idx_duas_navigation ON duas(published, position, id)',
  ],
  'malfuzats': [
    '''CREATE TABLE malfuzats (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      body TEXT,
      excerpt TEXT,
      language TEXT,
      has_audio INTEGER,
      audio_url TEXT,
      document_url TEXT,
      published INTEGER,
      published_at TEXT,
      position INTEGER,
      malfuzat_author_id TEXT,
      created_at TEXT,
      updated_at TEXT
    )''',
    '''CREATE TABLE malfuzat_authors (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      info TEXT,
      position INTEGER
    )''',
    '''CREATE TABLE malfuzat_categories (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      position INTEGER
    )''',
    '''CREATE TABLE malfuzat_categorizations (
      malfuzat_id TEXT NOT NULL,
      malfuzat_category_id TEXT NOT NULL,
      PRIMARY KEY (malfuzat_id, malfuzat_category_id)
    )''',
    'CREATE INDEX idx_malfuzats_author_id ON malfuzats(malfuzat_author_id)',
    'CREATE INDEX idx_malfuzats_navigation ON malfuzats(published, position, id)',
  ],
  'masails': [
    '''CREATE TABLE masails (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      question TEXT,
      answer TEXT,
      language TEXT,
      has_audio INTEGER,
      audio_url TEXT,
      document_url TEXT,
      published INTEGER,
      published_at TEXT,
      position INTEGER,
      masail_author_id TEXT,
      created_at TEXT,
      updated_at TEXT
    )''',
    '''CREATE TABLE masail_authors (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      info TEXT,
      position INTEGER
    )''',
    '''CREATE TABLE masail_categories (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      position INTEGER
    )''',
    '''CREATE TABLE masail_categorizations (
      masail_id TEXT NOT NULL,
      masail_category_id TEXT NOT NULL,
      PRIMARY KEY (masail_id, masail_category_id)
    )''',
    'CREATE INDEX idx_masails_author_id ON masails(masail_author_id)',
    'CREATE INDEX idx_masails_navigation ON masails(published, position, id)',
  ],
  'bayans': [
    '''CREATE TABLE bayans (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      excerpt TEXT,
      language TEXT,
      location TEXT,
      audio_url TEXT,
      published INTEGER,
      published_at TEXT,
      position INTEGER,
      speaker_id TEXT,
      created_at TEXT,
      updated_at TEXT
    )''',
    '''CREATE TABLE speakers (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      info TEXT,
      position INTEGER
    )''',
    '''CREATE TABLE bayan_categories (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      position INTEGER
    )''',
    '''CREATE TABLE bayan_categorizations (
      bayan_id TEXT NOT NULL,
      bayan_category_id TEXT NOT NULL,
      PRIMARY KEY (bayan_id, bayan_category_id)
    )''',
    'CREATE INDEX idx_bayans_speaker_id ON bayans(speaker_id)',
    'CREATE INDEX idx_bayans_navigation ON bayans(published, position, id)',
  ],
  'articles': [
    '''CREATE TABLE articles (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      body TEXT,
      excerpt TEXT,
      language TEXT,
      document_url TEXT,
      published INTEGER,
      published_at TEXT,
      position INTEGER,
      article_author_id TEXT,
      created_at TEXT,
      updated_at TEXT
    )''',
    '''CREATE TABLE article_authors (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      info TEXT,
      position INTEGER
    )''',
    '''CREATE TABLE article_categories (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      position INTEGER
    )''',
    '''CREATE TABLE article_categorizations (
      article_id TEXT NOT NULL,
      article_category_id TEXT NOT NULL,
      PRIMARY KEY (article_id, article_category_id)
    )''',
    'CREATE INDEX idx_articles_author_id ON articles(article_author_id)',
    'CREATE INDEX idx_articles_navigation ON articles(published, position, id)',
  ],
  'madrasahs': [
    '''CREATE TABLE madrasahs (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      excerpt TEXT,
      introduction TEXT,
      position INTEGER,
      created_at TEXT,
      updated_at TEXT
    )''',
    '''CREATE TABLE madrasah_infos (
      id TEXT PRIMARY KEY,
      madrasah_id TEXT,
      label TEXT,
      info TEXT,
      position INTEGER
    )''',
    '''CREATE TABLE madrasah_photos (
      id TEXT PRIMARY KEY,
      madrasah_id TEXT,
      title TEXT,
      image_url TEXT,
      position INTEGER
    )''',
    'CREATE INDEX idx_madrasah_infos_madrasah_id ON madrasah_infos(madrasah_id)',
    'CREATE INDEX idx_madrasah_photos_madrasah_id ON madrasah_photos(madrasah_id)',
    'CREATE INDEX idx_madrasahs_navigation ON madrasahs(position, id)',
  ],
  'misc': [
    '''CREATE TABLE pages (
      id TEXT PRIMARY KEY,
      title TEXT,
      slug TEXT,
      body TEXT,
      image_url TEXT,
      created_at TEXT,
      updated_at TEXT
    )''',
    'CREATE UNIQUE INDEX idx_pages_slug ON pages(slug)',
  ],
};

/// Which `OfflineSyncEngine` watermarks belong to each database.
///
/// Almost 1:1 with the schema keys — the exception is `misc`, which holds the
/// Pages table synced under the `pages` watermark by `MasailSyncService`.
/// Dropping a database's tables must clear these, or the next sync asks the
/// server for "everything changed since <before the wipe>", gets nothing back,
/// and leaves the feature permanently empty.
const Map<String, List<String>> _watermarkKeys = {
  'books': ['books'],
  'duas': ['duas'],
  'malfuzats': ['malfuzats'],
  'articles': ['articles'],
  'madrasahs': ['madrasahs'],
  'masails': ['masails'],
  'bayans': ['bayans'],
  'misc': ['pages'],
};

/// Every feature with a registered local schema (includes `misc`, which isn't
/// one of the synced *domains* in `offlineDbFeatures`).
Iterable<String> get registeredOfflineFeatures => _schemas.keys;

/// Clears the sync watermarks for [feature] so the next pass re-fetches that
/// domain from scratch.
Future<void> clearOfflineWatermarks(String feature) async {
  final keys = _watermarkKeys[feature];
  if (keys == null) return;
  final prefs = await SharedPreferences.getInstance();
  for (final key in keys) {
    await prefs.remove('offline_sync_since_$key');
  }
}

/// Opens a per-feature SQLite database for read-write access.
///
/// The database is created empty (schema only, from [_schemas]) the first
/// time it's opened, then populated incrementally by the corresponding
/// `X_sync_service.dart` — there is no bulk prebuilt file anymore.
///
/// Usage:
///   final helper = OfflineDatabaseHelper(feature: 'articles', version: 3);
///   final db = await helper.database;
class OfflineDatabaseHelper {
  static final Map<String, Database> _cache = {};

  final String feature;
  final int version;

  OfflineDatabaseHelper({required this.feature, required this.version});

  String get _dbFileName => '${feature}.sqlite3';

  Future<Database> get database async {
    if (_cache.containsKey(feature)) return _cache[feature]!;
    _cache[feature] = await _initDB();
    return _cache[feature]!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbFileName);

    final statements = _schemas[feature];
    if (statements == null) {
      throw StateError('No offline schema registered for feature "$feature"');
    }

    return openDatabase(
      path,
      version: version,
      onCreate: (db, v) async {
        for (final statement in statements) {
          await db.execute(statement);
        }
      },
      // A version bump means the schema changed shape (e.g. new column) —
      // simplest correct fix is to drop every existing table and rebuild
      // from scratch, since the sync engine immediately repopulates from
      // the server on the next run. Dropping via sqlite_master (rather than
      // re-parsing our own CREATE TABLE strings) also cleanly wipes tables
      // left over from the old prebuilt-file schema on upgrading installs.
      onUpgrade: (db, oldV, newV) async {
        final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%' AND name != 'android_metadata'",
        );
        for (final t in tables) {
          await db.execute('DROP TABLE IF EXISTS "${t['name']}"');
        }
        for (final statement in statements) {
          await db.execute(statement);
        }
        // The tables are now empty, so the server-side "changed since" cursor
        // no longer describes what's on disk. Without this the next sync
        // returns an empty delta and the feature stays empty forever.
        await clearOfflineWatermarks(feature);
      },
      // Navigation indexes are additive. Create them on every open so current
      // installs gain them without forcing a full feature re-sync.
      onOpen: (db) async {
        for (final statement
            in statements.where((s) => s.startsWith('CREATE INDEX'))) {
          await db.execute(statement.replaceFirst(
              'CREATE INDEX', 'CREATE INDEX IF NOT EXISTS'));
        }
      },
    );
  }

  /// Call this to force-close and evict a feature's DB from cache (e.g.
  /// before deleting the file entirely).
  static Future<void> evict(String feature) async {
    final db = _cache.remove(feature);
    await db?.close();
  }
}

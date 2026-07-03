import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/arabic_utils.dart';
import 'package:native_app/features/sura/models/ayah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/utils/database_helper.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  return DatabaseHelper().database;
});

final quranDataServiceProvider = Provider<QuranDataService>((ref) {
  return QuranDataService();
});

class QuranDataService {
  Future<List<Ayah>> getAyahsForSura(Database db, int suraNumber) async {
    final allDataFuture = Future.wait([
      db.query('ayahs', where: 'sura = ?', whereArgs: [suraNumber]),
      db.query('translations', where: 'sura = ?', whereArgs: [suraNumber]),
      db.query('words',
          where: 'sura = ?', whereArgs: [suraNumber], orderBy: 'word_id ASC'),
    ]);

    final allData = await allDataFuture;
    final List<Map<String, dynamic>> ayahData = allData[0];
    final List<Map<String, dynamic>> translationData = allData[1];
    final List<Map<String, dynamic>> wordData = allData[2];

    if (ayahData.isEmpty) {
      return [];
    }

    final Map<int, List<Translation>> translationsByAyah = {};
    for (final row in translationData) {
      final ayahNum = row['ayah'] as int;
      translationsByAyah
          .putIfAbsent(ayahNum, () => [])
          .add(Translation.fromDb(row));
    }

    final Map<int, List<WordByWord>> wordsByAyah = {};
    for (final row in wordData) {
      final ayahNum = row['ayah'] as int;
      wordsByAyah.putIfAbsent(ayahNum, () => []).add(WordByWord.fromDb(row));
    }

    final List<Ayah> resultAyahs = [];
    for (final row in ayahData) {
      final ayahNum = row['ayah'] as int;
      resultAyahs.add(Ayah.fromDb(
        row,
        translations: translationsByAyah[ayahNum] ?? [],
        words: wordsByAyah[ayahNum] ?? [],
      ));
    }

    return resultAyahs;
  }

  Future<int> getVerseCount(Database db, int suraNumber) async {
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ayahs WHERE sura = ?',
      [suraNumber],
    );
    return result.isNotEmpty ? Sqflite.firstIntValue(result) ?? 0 : 0;
  }

  Future<Ayah> getAyah(Database db, int suraNumber, int ayahNumber) async {
    final ayahMap = await db.query(
      'ayahs',
      where: 'sura = ? AND ayah = ?',
      whereArgs: [suraNumber, ayahNumber],
    );

    if (ayahMap.isEmpty) {
      throw Exception('Ayah not found: $suraNumber:$ayahNumber');
    }

    final translationsMap = await db.query(
      'translations',
      where: 'sura = ? AND ayah = ?',
      whereArgs: [suraNumber, ayahNumber],
    );
    final translations =
        translationsMap.map((row) => Translation.fromDb(row)).toList();

    final wordsMap = await db.query(
      'words',
      where: 'sura = ? AND ayah = ?',
      whereArgs: [suraNumber, ayahNumber],
      orderBy: 'word_id ASC',
    );
    final words = wordsMap.map((row) => WordByWord.fromDb(row)).toList();

    return Ayah.fromDb(ayahMap.first, translations: translations, words: words);
  }

  Future<({List<String> keys, Map<String, String> translationMatches})>
      searchQuranKeys(Database db, String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return (keys: <String>[], translationMatches: <String, String>{});

    final stripped = stripArabicDiacritics(trimmed);

    final arabicMatchKeys = <String>{};
    if (stripped.isNotEmpty) {
      final rows = await db.rawQuery(
        'SELECT DISTINCT sura, ayah FROM ayahs WHERE arabic_text_plain LIKE ?',
        ['%$stripped%'],
      );
      for (final r in rows) {
        arabicMatchKeys.add('${r['sura']}:${r['ayah']}');
      }
    }

    final translationMatchTexts = <String, String>{};
    final translRows = await db.rawQuery(
      'SELECT sura, ayah, MIN(translation_text) AS matched_text '
      'FROM translations WHERE translation_text LIKE ? GROUP BY sura, ayah',
      ['%$trimmed%'],
    );
    for (final r in translRows) {
      translationMatchTexts['${r['sura']}:${r['ayah']}'] =
          r['matched_text'] as String;
    }

    final allKeys = {...arabicMatchKeys, ...translationMatchTexts.keys}.toList();
    allKeys.sort((a, b) {
      final ap = a.split(':'), bp = b.split(':');
      final s = int.parse(ap[0]).compareTo(int.parse(bp[0]));
      return s != 0 ? s : int.parse(ap[1]).compareTo(int.parse(bp[1]));
    });

    return (keys: allKeys, translationMatches: translationMatchTexts);
  }

  Future<List<SearchResult>> fetchSearchResults(
    Database db,
    List<String> allKeys,
    Map<String, String> translationMatches, {
    int offset = 0,
    int limit = 20,
  }) async {
    final page = allKeys.skip(offset).take(limit).toList();
    if (page.isEmpty) return [];

    final whereClause =
        page.map((_) => '(sura = ? AND ayah = ?)').join(' OR ');
    final whereArgs = page.expand((k) {
      final p = k.split(':');
      return [int.parse(p[0]), int.parse(p[1])];
    }).toList();

    final ayahRows =
        await db.query('ayahs', where: whereClause, whereArgs: whereArgs);

    return ayahRows.map((row) {
      final key = '${row['sura']}:${row['ayah']}';
      return SearchResult(
        sura: row['sura'] as int,
        ayah: row['ayah'] as int,
        arabicText: row['arabic_text'] as String,
        matchedTranslation: translationMatches[key],
      );
    }).toList()
      ..sort((a, b) {
        final s = a.sura.compareTo(b.sura);
        return s != 0 ? s : a.ayah.compareTo(b.ayah);
      });
  }
}

final suraDataProvider = FutureProvider.family<List<Ayah>, int>((
  ref,
  suraNumber,
) async {
  final db = await ref.watch(databaseProvider.future);
  return ref.read(quranDataServiceProvider).getAyahsForSura(db, suraNumber);
});

final ayahCountProvider = FutureProvider.family<int, int>((
  ref,
  suraNumber,
) async {
  final db = await ref.watch(databaseProvider.future);
  return ref.read(quranDataServiceProvider).getVerseCount(db, suraNumber);
});

class AyahProviderParams {
  final int suraNumber;
  final int index;
  AyahProviderParams({required this.suraNumber, required this.index});
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahProviderParams &&
          runtimeType == other.runtimeType &&
          suraNumber == other.suraNumber &&
          index == other.index;
  @override
  int get hashCode => suraNumber.hashCode ^ index.hashCode;
}

final ayahByIndexProvider = FutureProvider.family<Ayah, AyahProviderParams>((
  ref,
  params,
) async {
  final db = await ref.watch(databaseProvider.future);
  final ayahNumber = params.index + 1;
  return ref
      .read(quranDataServiceProvider)
      .getAyah(db, params.suraNumber, ayahNumber);
});

const String _selectedTranslatorsKey = 'sura_selected_translators';

class SelectedTranslatorsNotifier extends StateNotifier<List<String>> {
  SelectedTranslatorsNotifier() : super([]) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_selectedTranslatorsKey);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> setTranslators(List<String> translators) async {
    state = translators;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedTranslatorsKey, translators);
  }

  Future<void> addTranslator(String translator) async {
    if (!state.contains(translator)) {
      state = [...state, translator];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_selectedTranslatorsKey, state);
    }
  }

  Future<void> removeTranslator(String translator) async {
    state = state.where((t) => t != translator).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedTranslatorsKey, state);
  }

  Future<void> toggleTranslator(String translator) async {
    if (state.contains(translator)) {
      await removeTranslator(translator);
    } else {
      await addTranslator(translator);
    }
  }
}

final selectedTranslatorsProvider =
    StateNotifierProvider<SelectedTranslatorsNotifier, List<String>>((ref) {
  return SelectedTranslatorsNotifier();
});

class ScrollCommand {
  final int suraNumber;
  final int scrollIndex;

  ScrollCommand({required this.suraNumber, required this.scrollIndex});
}

final activeSurahPagesProvider = StateProvider<Set<int>>((ref) => {});
final suraScrollCommandProvider = StateProvider<ScrollCommand?>((ref) => null);

/// Command to open tafsir after navigation - contains sura and ayah number
class OpenTafsirCommand {
  final int suraNumber;
  final int ayahNumber;

  OpenTafsirCommand({required this.suraNumber, required this.ayahNumber});
}

final openTafsirCommandProvider =
    StateProvider<OpenTafsirCommand?>((ref) => null);
final showTranslationsProvider = StateProvider<bool>((ref) => true);
final showWordByWordProvider = StateProvider<bool>((ref) => false);
final isAutoScrollingProvider = StateProvider<bool>((ref) => false);
final scrollSpeedFactorProvider = StateProvider<double>((ref) => 1.0);
final isAutoScrollPausedProvider = StateProvider<bool>((ref) => false);

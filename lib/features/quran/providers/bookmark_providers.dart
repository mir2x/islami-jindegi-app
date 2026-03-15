import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ayah_highlight_providers.dart';
import '../models/bookmark.dart';

class BookmarkNotifier extends AsyncNotifier<List<Bookmark>> {
  static const _bookmarkKey = 'bookmarks';
  static const _legacyAyahBookmarkKey = 'ayah_bookmarks';

  @override
  Future<List<Bookmark>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_bookmarkKey) ?? [];
    final bookmarks =
        raw.map((e) => Bookmark.fromJson(jsonDecode(e))).toList(growable: true);

    final legacyRaw = prefs.getString(_legacyAyahBookmarkKey);
    if (legacyRaw != null && legacyRaw.isNotEmpty) {
      final quranInfoService = ref.read(quranInfoServiceProvider);
      final legacyItems =
          (jsonDecode(legacyRaw) as List<dynamic>).cast<Map<String, dynamic>>();

      for (final item in legacyItems) {
        final sura = item['suraNumber'] as int?;
        final ayah = item['ayahNumber'] as int?;
        if (sura == null || ayah == null) continue;

        final identifier = 'ayah-$sura-$ayah';
        if (bookmarks.any((bookmark) => bookmark.identifier == identifier)) {
          continue;
        }

        bookmarks.add(
          Bookmark(
            type: 'ayah',
            identifier: identifier,
            timestamp: DateTime.tryParse(item['createdAt'] as String? ?? ''),
            sura: sura,
            ayah: ayah,
            para: quranInfoService.getParaBySuraAyah(sura, ayah),
            page: quranInfoService.getPageBySuraAyah(sura, ayah),
          ),
        );
      }

      await _persist(bookmarks);
    }

    bookmarks.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return bookmarks;
  }

  Future<void> add(Bookmark b) async {
    final list = List<Bookmark>.from(state.value ?? []);
    if (list.any((e) => e.identifier == b.identifier)) return;
    list.add(b);
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    state = AsyncData(list);
    await _persist(list);
  }

  Future<void> remove(String id) async {
    final list = List<Bookmark>.from(state.value ?? []);
    list.removeWhere((b) => b.identifier == id);
    state = AsyncData(list);
    await _persist(list);
  }

  Future<void> _persist(List<Bookmark> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _bookmarkKey,
      data.map((b) => jsonEncode(b.toJson())).toList(),
    );
  }

  bool isAyahBookmarked(int sura, int ayah) {
    if (!state.hasValue || state.value == null) {
      return false;
    }
    return state.value!.any(
      (b) => b.type == 'ayah' && b.sura == sura && b.ayah == ayah,
    );
  }

  bool isPageBookmarked(int page) {
    if (!state.hasValue || state.value == null) {
      return false;
    }
    return state.value!.any(
      (b) => b.type == 'page' && b.page == page,
    );
  }
}

final bookmarkProvider =
    AsyncNotifierProvider<BookmarkNotifier, List<Bookmark>>(
  BookmarkNotifier.new,
);

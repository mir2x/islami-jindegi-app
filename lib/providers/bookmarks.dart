import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/bookmarks/models/bookmark.dart';

const _storageKey = 'bookmarks_store';

Future<List<Bookmark>> _loadAll() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_storageKey) ?? [];
  return raw.map((e) => Bookmark.fromJson(jsonDecode(e))).toList();
}

Future<void> _saveAll(List<Bookmark> items) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    _storageKey,
    items.map((e) => jsonEncode(e.toJson())).toList(),
  );
}

int _nextId(List<Bookmark> items) {
  if (items.isEmpty) return 1;
  return items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
}

class BookmarkNotifier extends AsyncNotifier<Bookmark?> {
  BookmarkNotifier(this.arg);
  final String arg;

  @override
  Future<Bookmark?> build() async {
    final items = await _loadAll();
    return items.cast<Bookmark?>().firstWhere(
          (b) => b?.link == arg,
          orElse: () => null,
        );
  }

  Future<dynamic> createItem(Map attrs) async {
    final items = await _loadAll();
    final newBookmark = Bookmark(
      id: _nextId(items),
      type: attrs['type'],
      title: attrs['title'],
      link: attrs['link'],
      createdAt: DateTime.now(),
    );

    // Remove existing with same link (upsert behavior)
    items.removeWhere((b) => b.link == newBookmark.link);
    items.add(newBookmark);
    await _saveAll(items);
    state = AsyncValue.data(newBookmark);
  }

  Future<dynamic> deleteItem(id) async {
    final items = await _loadAll();
    items.removeWhere((b) => b.id == id);
    await _saveAll(items);
    state = const AsyncValue.data(null);
  }
}

final bookmarkProvider = AsyncNotifierProvider.autoDispose
    .family<BookmarkNotifier, Bookmark?, String>(
  BookmarkNotifier.new,
);

class BookmarksNotifier extends AsyncNotifier<List> {
  @override
  Future<List> build() async {
    final items = await _loadAll();
    items.sort((a, b) =>
        (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    return items;
  }

  Future<dynamic> deleteItem(id) async {
    final items = await _loadAll();
    items.removeWhere((b) => b.id == id);
    await _saveAll(items);
    items.sort((a, b) =>
        (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    state = AsyncValue.data(items);
  }
}

final bookmarksProvider =
    AsyncNotifierProvider.autoDispose<BookmarksNotifier, List>(() {
  return BookmarksNotifier();
});

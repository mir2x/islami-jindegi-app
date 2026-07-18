import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/book/models/downloaded_book.dart';

const _storageKey = 'downloaded_books_store';

Future<List<DownloadedBook>> _loadAll() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_storageKey) ?? [];
  return raw.map((e) => DownloadedBook.fromJson(jsonDecode(e))).toList();
}

Future<void> _saveAll(List<DownloadedBook> items) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    _storageKey,
    items.map((e) => jsonEncode(e.toJson())).toList(),
  );
}

int _nextId(List<DownloadedBook> items) {
  if (items.isEmpty) return 1;
  return items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
}

final getDownloadedBookProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final items = await _loadAll();
  return items.cast<DownloadedBook?>().firstWhere(
        (b) => b?.id == id,
        orElse: () => null,
      );
});

final getDownloadedBookByIdProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String bookId) async {
  final items = await _loadAll();
  return items.cast<DownloadedBook?>().firstWhere(
        (b) => b?.bookId == bookId,
        orElse: () => null,
      );
});

final createDownloadedBookProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final items = await _loadAll();
  final newResource = DownloadedBook(
    id: _nextId(items),
    bookId: attrs['bookId'],
    title: attrs['title'],
    excerpt: attrs['excerpt'],
    publisher: attrs['publisher'],
    price: attrs['price'],
    image: attrs['image'],
    document: attrs['document'],
    authors: attrs['authors'],
    publishedAt: attrs['publishedAt'],
  );

  items.removeWhere((b) => b.bookId == newResource.bookId);
  items.add(newResource);
  await _saveAll(items);
});

final deleteDownloadedBookProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String bookId) async {
  final items = await _loadAll();
  items.removeWhere((b) => b.bookId == bookId);
  await _saveAll(items);
});

class DownloadedBooksNotifier extends AsyncNotifier<List> {
  @override
  Future<List> build() async {
    final items = await _loadAll();
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    return items;
  }

  Future<dynamic> deleteItem(bookId) async {
    final items = await _loadAll();
    items.removeWhere((b) => b.bookId == bookId);
    await _saveAll(items);
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    state = AsyncValue.data(items);
  }
}

final downloadedBooksProvider =
    AsyncNotifierProvider.autoDispose<DownloadedBooksNotifier, List>(() {
  return DownloadedBooksNotifier();
});

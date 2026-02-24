import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/downloaded_book.dart';

const _storageKey = 'downloaded_books_v2';

// ═══════════════════════════════════════════════════
//  SharedPreferences instance
// ═══════════════════════════════════════════════════

final _prefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// ═══════════════════════════════════════════════════
//  Downloaded books list (notifier for CRUD)
// ═══════════════════════════════════════════════════

class DownloadedBooksNotifier
    extends AutoDisposeAsyncNotifier<List<DownloadedBook>> {
  @override
  Future<List<DownloadedBook>> build() async {
    final prefs = await ref.watch(_prefsProvider.future);
    final raw = prefs.getStringList(_storageKey) ?? [];
    return raw.map((e) => DownloadedBook.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _save(List<DownloadedBook> entries) async {
    final prefs = await ref.read(_prefsProvider.future);
    await prefs.setStringList(
      _storageKey,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  /// Add or update a downloaded book entry.
  Future<void> saveBook(DownloadedBook entry) async {
    final current = state.value ?? [];
    // Remove existing entry with same bookId if any
    final updated = current.where((e) => e.bookId != entry.bookId).toList();
    updated.insert(0, entry);
    // Sort by publishedAt descending (same as old Isar sort)
    updated.sort((a, b) {
      final aDate = a.publishedAt ?? '';
      final bDate = b.publishedAt ?? '';
      return bDate.compareTo(aDate);
    });
    await _save(updated);
    state = AsyncValue.data(updated);
  }

  /// Delete a downloaded book by its bookId.
  Future<void> deleteBook(String bookId) async {
    final current = state.value ?? [];
    final updated = current.where((e) => e.bookId != bookId).toList();
    await _save(updated);
    state = AsyncValue.data(updated);
  }
}

final downloadedBooksProvider = AsyncNotifierProvider.autoDispose<
    DownloadedBooksNotifier, List<DownloadedBook>>(() {
  return DownloadedBooksNotifier();
});

// ═══════════════════════════════════════════════════
//  Single downloaded book lookups
// ═══════════════════════════════════════════════════

/// Get a downloaded book entry by its bookId.
final downloadedBookByBookIdProvider = FutureProvider.autoDispose
    .family<DownloadedBook?, String>((ref, bookId) async {
  final books = await ref.watch(downloadedBooksProvider.future);
  try {
    return books.firstWhere((e) => e.bookId == bookId);
  } catch (_) {
    return null;
  }
});

/// Create a downloaded book entry from a map (matches old Isar createDownloadedBookProvider API).
final createDownloadedBookProvider = FutureProvider.autoDispose
    .family<void, Map<String, dynamic>>((ref, attrs) async {
  final entry = DownloadedBook(
    bookId: attrs['bookId']?.toString() ?? '',
    title: attrs['title']?.toString(),
    excerpt: attrs['excerpt']?.toString(),
    publisher: attrs['publisher']?.toString(),
    price: attrs['price']?.toString(),
    image: attrs['image']?.toString(),
    document: attrs['document']?.toString(),
    authors: attrs['authors']?.toString(),
    publishedAt: attrs['publishedAt']?.toString(),
  );
  await ref.read(downloadedBooksProvider.notifier).saveBook(entry);
});

/// Delete a downloaded book by its bookId.
final deleteDownloadedBookProvider =
    FutureProvider.autoDispose.family<void, String>((ref, bookId) async {
  await ref.read(downloadedBooksProvider.notifier).deleteBook(bookId);
});

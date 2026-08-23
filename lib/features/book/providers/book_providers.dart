import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:native_app/core/providers/connectivity.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
import '../models/book.dart';
import '../models/book_author.dart';
import '../models/book_chapter.dart';
import '../models/book_subchapter.dart';
import '../models/book_category.dart';
import 'book_api_service.dart';
import 'book_offline_service.dart';
import 'book_progress_provider.dart';

// ═══════════════════════════════════════════════════
//  Service singletons
// ═══════════════════════════════════════════════════

final bookApiServiceProvider = Provider((ref) => BookApiService());
final bookOfflineServiceProvider = Provider((ref) => BookOfflineService());

// ═══════════════════════════════════════════════════
//  Query params (filter/search state)
// ═══════════════════════════════════════════════════

final bookQueryParamsProvider =
    NotifierProvider.autoDispose<BookQueryParamsNotifier, Map<String, dynamic>>(
        BookQueryParamsNotifier.new);

class BookQueryParamsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {};

  void updateParam(String key, dynamic value) {
    if (value == null || (value is String && value.isEmpty)) {
      state = Map.from(state)..remove(key);
    } else {
      state = {...state, key: value};
    }
  }

  void removeParam(String key) {
    state = Map.from(state)..remove(key);
  }

  void clearAll() {
    state = {};
  }
}

// ═══════════════════════════════════════════════════
//  Book list
// ═══════════════════════════════════════════════════

/// Fetches a page of books. In online mode uses API, offline falls back to DB.
final bookListProvider = FutureProvider.autoDispose
    .family<List<Book>, Map<String, dynamic>>((ref, params) async {
  final isConnected = await ref.watch(connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchBooks(
        page: params['page'] ?? 1,
        perPage: params['perPage'] ?? 20,
        search: params['search'],
        authorId: params['authorId'],
        categoryId: params['categoryId'],
      );
    } catch (e) {
      if (!shouldFallbackToOffline(e)) rethrow;
      // Fallback to offline on network error
      return await offline.queryBooks(
        page: params['page'],
        perPage: params['perPage'],
      );
    }
  } else {
    return await offline.queryBooks(
      page: params['page'],
      perPage: params['perPage'],
    );
  }
});

// ═══════════════════════════════════════════════════
//  Single book detail
// ═══════════════════════════════════════════════════

final bookDetailProvider =
    FutureProvider.autoDispose.family<Book?, String>((ref, id) async {
  debugPrint('[bookDetailProvider] Fetching book: $id');
  final isConnected = await ref.watch(connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      debugPrint('[bookDetailProvider] Trying API for book: $id');
      final book = await api.fetchBook(id);
      debugPrint('[bookDetailProvider] API success: ${book.title}');
      return book;
    } catch (e) {
      debugPrint('[bookDetailProvider] API error: $e');
      if (e is DioException && e.response?.statusCode == 404) {
        ref.read(bookProgressProvider.notifier).clearBook(id);
      }
      if (!shouldFallbackToOffline(e)) rethrow;
      debugPrint(
        '[bookDetailProvider] Falling back to offline for book: $id',
      );
      final offlineBook = await offline.findBookById(id);
      debugPrint(
        '[bookDetailProvider] Offline result: ${offlineBook?.title ?? 'null'}',
      );
      return offlineBook;
    }
  } else {
    debugPrint('[bookDetailProvider] Offline mode for book: $id');
    return await offline.findBookById(id);
  }
});

// ═══════════════════════════════════════════════════
//  Chapters
// ═══════════════════════════════════════════════════

/// Parameter class with proper equality for chapter list queries.
class ChapterListParams {
  final String bookId;
  final bool includeSubchapters;
  final int? quantity;
  final String? sort;
  final int? position;

  const ChapterListParams({
    required this.bookId,
    this.includeSubchapters = false,
    this.quantity,
    this.sort,
    this.position,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterListParams &&
          runtimeType == other.runtimeType &&
          bookId == other.bookId &&
          includeSubchapters == other.includeSubchapters &&
          quantity == other.quantity &&
          sort == other.sort &&
          position == other.position;

  @override
  int get hashCode => Object.hash(
        bookId,
        includeSubchapters,
        quantity,
        sort,
        position,
      );
}

/// Fetch chapters for a book.
final chapterListProvider = FutureProvider.autoDispose
    .family<List<BookChapter>, ChapterListParams>((ref, params) async {
  debugPrint(
    '[chapterListProvider] Fetching chapters for bookId=${params.bookId} qty=${params.quantity} sort=${params.sort}',
  );
  final isConnected = await ref.watch(connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      // .NET returns the full chapter+subchapter tree for a book in one call;
      // quantity/sort/position only apply to the offline SQLite fallback below.
      final chapters = await api.fetchChaptersByBook(params.bookId);
      debugPrint(
        '[chapterListProvider] API returned ${chapters.length} chapters',
      );
      return chapters;
    } catch (e) {
      debugPrint(
        '[chapterListProvider] API error: $e, falling back to offline',
      );
      return await offline.queryChapters(
        bookId: params.bookId,
        quantity: params.quantity,
        sort: params.sort,
        position: params.position,
        includeSubchapters: params.includeSubchapters,
      );
    }
  } else {
    return await offline.queryChapters(
      bookId: params.bookId,
      quantity: params.quantity,
      sort: params.sort,
      position: params.position,
      includeSubchapters: params.includeSubchapters,
    );
  }
});

/// Fetch a single chapter by ID.
final chapterDetailProvider =
    FutureProvider.autoDispose.family<BookChapter?, String>((ref, id) async {
  final isConnected = await ref.watch(connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchChapter(id);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        ref.read(bookProgressProvider.notifier).clearNode(id);
      }
      if (!shouldFallbackToOffline(e)) rethrow;
      return await offline.findChapterById(id);
    }
  } else {
    return await offline.findChapterById(id);
  }
});

// ═══════════════════════════════════════════════════
//  Subchapters
// ═══════════════════════════════════════════════════

/// Fetch a single subchapter by ID.
final subchapterDetailProvider =
    FutureProvider.autoDispose.family<BookSubchapter?, String>((ref, id) async {
  final isConnected = await ref.watch(connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchSubchapter(id);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        ref.read(bookProgressProvider.notifier).clearNode(id);
      }
      if (!shouldFallbackToOffline(e)) rethrow;
      return await offline.findSubchapterById(id, includeChapter: true);
    }
  } else {
    return await offline.findSubchapterById(id, includeChapter: true);
  }
});

// ═══════════════════════════════════════════════════
//  Filters (Authors & Categories) — online only
// ═══════════════════════════════════════════════════

final singleAuthorProvider =
    FutureProvider.autoDispose.family<BookAuthor?, String>((ref, id) async {
  final isConnected = await ref.watch(connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchAuthor(id);
    } catch (_) {
      return await offline.findAuthorById(id);
    }
  } else {
    return await offline.findAuthorById(id);
  }
});

final singleCategoryProvider =
    FutureProvider.autoDispose.family<BookCategory?, String>((ref, id) async {
  final api = ref.read(bookApiServiceProvider);
  return await api.fetchBookCategory(id);
});

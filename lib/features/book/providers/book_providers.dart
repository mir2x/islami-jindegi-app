import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/book.dart';
import '../models/book_author.dart';
import '../models/book_chapter.dart';
import '../models/book_subchapter.dart';
import '../models/book_category.dart';
import 'book_api_service.dart';
import 'book_offline_service.dart';

// ═══════════════════════════════════════════════════
//  Service singletons
// ═══════════════════════════════════════════════════

final bookApiServiceProvider = Provider((ref) => BookApiService());
final bookOfflineServiceProvider = Provider((ref) => BookOfflineService());

// ═══════════════════════════════════════════════════
//  Connectivity
// ═══════════════════════════════════════════════════

final _connectivityProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  final isConnected = !result.contains(ConnectivityResult.none);
  debugPrint(
      '[BookProviders] Connectivity check: $isConnected (results: $result)');
  return isConnected;
});

// ═══════════════════════════════════════════════════
//  Query params (filter/search state)
// ═══════════════════════════════════════════════════

final bookQueryParamsProvider =
    StateNotifierProvider<BookQueryParamsNotifier, Map<String, dynamic>>((ref) {
  return BookQueryParamsNotifier();
});

class BookQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  BookQueryParamsNotifier() : super({});

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
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchBooks(
        page: params['page'] ?? 1,
        perPage: params['perPage'] ?? 20,
        search: params['search'],
        authorId: params['authorId'],
        bookCategoryId: params['bookCategoryId'],
        bookSubcategoryId: params['bookSubcategoryId'],
      );
    } catch (e) {
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

/// Cached ordered book IDs for previous/next navigation.
/// Invalidate with `ref.invalidate(bookNavigationIdsProvider)` if the
/// catalogue is refreshed during the current app session.
final bookNavigationIdsProvider = FutureProvider<List<String>>((ref) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);
  const perPage = 12;
  final ids = <String>[];

  if (isConnected) {
    try {
      int page = 1;
      while (true) {
        final books = await api.fetchBooks(
          page: page,
          perPage: perPage,
          includeAuthors: false,
        );
        if (books.isEmpty) break;
        ids.addAll(books.map((book) => book.id));
        if (books.length < perPage) break;
        page++;
      }

      return ids;
    } catch (e) {
      debugPrint('[bookNavigationIdsProvider] API error: $e');
    }
  }

  int page = 1;
  while (true) {
    final books = await offline.queryBooks(
      page: page,
      perPage: perPage,
    );
    if (books.isEmpty) break;
    ids.addAll(books.map((book) => book.id));
    if (books.length < perPage) break;
    page++;
  }

  return ids;
});

// ═══════════════════════════════════════════════════
//  Single book detail
// ═══════════════════════════════════════════════════

final bookDetailProvider =
    FutureProvider.autoDispose.family<Book?, String>((ref, id) async {
  debugPrint('[bookDetailProvider] Fetching book: $id');
  final isConnected = await ref.watch(_connectivityProvider.future);
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
      debugPrint('[bookDetailProvider] Falling back to offline for book: $id');
      final offlineBook = await offline.findBookById(id);
      debugPrint(
          '[bookDetailProvider] Offline result: ${offlineBook?.title ?? 'null'}');
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
      '[chapterListProvider] Fetching chapters for bookId=${params.bookId} qty=${params.quantity} sort=${params.sort}');
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      final chapters = await api.fetchChapters(
        bookId: params.bookId,
        quantity: params.quantity,
        sort: params.sort,
        position: params.position,
        includeSubchapters: params.includeSubchapters,
      );
      debugPrint(
          '[chapterListProvider] API returned ${chapters.length} chapters');
      return chapters;
    } catch (e) {
      debugPrint(
          '[chapterListProvider] API error: $e, falling back to offline');
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
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchChapter(id);
    } catch (_) {
      return await offline.findChapterById(id);
    }
  } else {
    return await offline.findChapterById(id);
  }
});

// ═══════════════════════════════════════════════════
//  Subchapters
// ═══════════════════════════════════════════════════

/// Parameter class with proper equality for subchapter list queries.
class SubchapterListParams {
  final String chapterId;
  final int? quantity;
  final int? position;

  const SubchapterListParams({
    required this.chapterId,
    this.quantity,
    this.position,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubchapterListParams &&
          runtimeType == other.runtimeType &&
          chapterId == other.chapterId &&
          quantity == other.quantity &&
          position == other.position;

  @override
  int get hashCode => Object.hash(chapterId, quantity, position);
}

/// Fetch subchapters.
final subchapterListProvider = FutureProvider.autoDispose
    .family<List<BookSubchapter>, SubchapterListParams>((ref, params) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchSubchapters(
        chapterId: params.chapterId,
        quantity: params.quantity,
        position: params.position,
      );
    } catch (_) {
      return await offline.querySubchapters(
        chapterId: params.chapterId,
        quantity: params.quantity,
        position: params.position,
      );
    }
  } else {
    return await offline.querySubchapters(
      chapterId: params.chapterId,
      quantity: params.quantity,
      position: params.position,
    );
  }
});

/// Fetch a single subchapter by ID.
final subchapterDetailProvider =
    FutureProvider.autoDispose.family<BookSubchapter?, String>((ref, id) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);

  if (isConnected) {
    try {
      return await api.fetchSubchapter(id, includeChapter: true);
    } catch (_) {
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
  final isConnected = await ref.watch(_connectivityProvider.future);
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

final singleSubcategoryProvider = FutureProvider.autoDispose
    .family<BookSubcategory?, String>((ref, id) async {
  final api = ref.read(bookApiServiceProvider);
  return await api.fetchBookSubcategory(id);
});

// ═══════════════════════════════════════════════════
//  Last visited chapter tracking
// ═══════════════════════════════════════════════════

final bookLastChapterProvider =
    StateNotifierProvider<BookLastChapterNotifier, Map<String, String>>((ref) {
  return BookLastChapterNotifier();
});

class BookLastChapterNotifier extends StateNotifier<Map<String, String>> {
  BookLastChapterNotifier() : super({});

  void updateLastChapter(String bookId, String chapterId) {
    state = {...state, bookId: chapterId};
  }

  String? getLastChapterId(String bookId) {
    return state[bookId];
  }
}

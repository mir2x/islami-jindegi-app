import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/providers/shared_preferences.dart';

import '../models/book_reading_progress.dart';

const _storageKey = 'book_reading_progress';
const _maxBooks = 100;

class BookProgressState {
  const BookProgressState({required this.lastBookId, required this.books});

  final String? lastBookId;
  final Map<String, BookReadingProgress> books;

  BookReadingProgress? get last =>
      lastBookId == null ? null : books[lastBookId!];

  BookReadingProgress? forBook(String bookId) => books[bookId];

  BookProgressState copyWith({
    String? lastBookId,
    bool clearLastBook = false,
    Map<String, BookReadingProgress>? books,
  }) =>
      BookProgressState(
        lastBookId: clearLastBook ? null : lastBookId ?? this.lastBookId,
        books: books ?? this.books,
      );
}

final bookProgressProvider =
    NotifierProvider<BookProgressNotifier, BookProgressState>(
  BookProgressNotifier.new,
);

class BookProgressNotifier extends Notifier<BookProgressState> {
  Timer? _writeDebounce;

  @override
  BookProgressState build() {
    ref.onDispose(() => _writeDebounce?.cancel());
    final prefs = ref.read(sharedPreferencesProvider);
    final saved = prefs.getString(_storageKey);
    if (saved != null) return _decode(saved);

    // The old data has only IDs (and no chapter kind), so preserve it for the
    // TOC marker but route the migrated card to the book safely.
    final legacyBookId = prefs.getString('lastBook');
    final legacyChapters =
        _decodeLegacyChapters(prefs.getString('lastChapters'));
    if (legacyBookId == null && legacyChapters.isEmpty) {
      return const BookProgressState(lastBookId: null, books: {});
    }
    final now = DateTime.now();
    final books = <String, BookReadingProgress>{
      for (final entry in legacyChapters.entries)
        entry.key: BookReadingProgress(
          bookId: entry.key,
          bookTitle: '',
          nodeId: entry.value,
          updatedAt: now,
        ),
    };
    if (legacyBookId != null) {
      books.putIfAbsent(
        legacyBookId,
        () => BookReadingProgress(
          bookId: legacyBookId,
          bookTitle: '',
          updatedAt: now,
        ),
      );
    }
    final migrated = BookProgressState(lastBookId: legacyBookId, books: books);
    _persistNow(migrated);
    unawaited(prefs.remove('lastBook'));
    unawaited(prefs.remove('lastBookIndex'));
    unawaited(prefs.remove('lastChapters'));
    return migrated;
  }

  BookReadingProgress? forBook(String bookId) => state.books[bookId];

  void openedBook(String bookId, String bookTitle) {
    final existing = state.books[bookId];
    if (state.lastBookId == bookId && existing?.bookTitle == bookTitle) return;
    final now = DateTime.now();
    final current = existing;
    _set(
      BookReadingProgress(
        bookId: bookId,
        bookTitle: bookTitle,
        nodeId: current?.nodeId,
        nodeTitle: current?.nodeTitle,
        nodeKind: current?.nodeKind,
        updatedAt: now,
      ),
    );
  }

  void openedNode(
    String bookId,
    String nodeId,
    String nodeTitle,
    BookNodeKind nodeKind, {
    String? bookTitle,
  }) {
    final current = state.books[bookId];
    final resolvedBookTitle =
        bookTitle?.isNotEmpty == true ? bookTitle! : current?.bookTitle ?? '';
    if (state.lastBookId == bookId &&
        current?.nodeId == nodeId &&
        current?.nodeTitle == nodeTitle &&
        current?.nodeKind == nodeKind &&
        current?.bookTitle == resolvedBookTitle) return;
    _set(
      BookReadingProgress(
        bookId: bookId,
        bookTitle: resolvedBookTitle,
        nodeId: nodeId,
        nodeTitle: nodeTitle,
        nodeKind: nodeKind,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Removes a record after an authoritative online 404.
  void clearBook(String bookId) {
    if (!state.books.containsKey(bookId)) return;
    _writeDebounce?.cancel();
    final books = Map<String, BookReadingProgress>.from(state.books)
      ..remove(bookId);
    state = state.copyWith(
      books: books,
      clearLastBook: state.lastBookId == bookId,
    );
    _schedulePersist();
  }

  void clearNode(String nodeId) {
    MapEntry<String, BookReadingProgress>? entry;
    for (final candidate in state.books.entries) {
      if (candidate.value.nodeId == nodeId) {
        entry = candidate;
        break;
      }
    }
    if (entry == null) return;
    // A 404 is authoritative online state: keeping the book as a fallback
    // would leave a card that points at an unpublished/deleted destination.
    clearBook(entry.key);
  }

  void _set(BookReadingProgress progress) {
    final books = Map<String, BookReadingProgress>.from(state.books)
      ..[progress.bookId] = progress;
    if (books.length > _maxBooks) {
      final oldest = books.values.reduce(
        (a, b) => a.updatedAt.isBefore(b.updatedAt) ? a : b,
      );
      books.remove(oldest.bookId);
    }
    state = BookProgressState(lastBookId: progress.bookId, books: books);
    _schedulePersist();
  }

  void _schedulePersist() {
    _writeDebounce?.cancel();
    _writeDebounce = Timer(const Duration(milliseconds: 350), () {
      _persistNow(state);
    });
  }

  void _persistNow(BookProgressState value) {
    final encoded = jsonEncode({
      if (value.lastBookId != null) 'lastBookId': value.lastBookId,
      'books': {
        for (final entry in value.books.entries)
          entry.key: entry.value.toJson(),
      },
    });
    unawaited(
      ref.read(sharedPreferencesProvider).setString(_storageKey, encoded),
    );
  }

  BookProgressState _decode(String encoded) {
    try {
      final data = jsonDecode(encoded) as Map<String, dynamic>;
      final rawBooks = data['books'] as Map<String, dynamic>? ?? {};
      return BookProgressState(
        lastBookId: data['lastBookId'] as String?,
        books: {
          for (final entry in rawBooks.entries)
            if (entry.value is Map)
              entry.key: BookReadingProgress.fromJson(
                entry.key,
                Map<String, dynamic>.from(entry.value as Map),
              ),
        },
      );
    } catch (_) {
      return const BookProgressState(lastBookId: null, books: {});
    }
  }

  Map<String, String> _decodeLegacyChapters(String? raw) {
    if (raw == null) return {};
    try {
      final value = jsonDecode(raw) as Map<String, dynamic>;
      return value.map((key, value) => MapEntry(key, value.toString()));
    } catch (_) {
      return {};
    }
  }
}

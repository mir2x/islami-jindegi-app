import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/book.dart';
import 'book_providers.dart';

class BookListKey {
  const BookListKey({this.search, this.authorId, this.categoryId});

  factory BookListKey.fromParams(Map<String, dynamic> params) => BookListKey(
        search: _stringOrNull(params['search']),
        authorId: _stringOrNull(params['authorId']),
        categoryId: _stringOrNull(params['categoryId']),
      );

  final String? search;
  final String? authorId;
  final String? categoryId;

  Map<String, dynamic> get queryParams => {
        if (search != null) 'search': search,
        if (authorId != null) 'authorId': authorId,
        if (categoryId != null) 'categoryId': categoryId,
      };

  @override
  bool operator ==(Object other) =>
      other is BookListKey &&
      other.search == search &&
      other.authorId == authorId &&
      other.categoryId == categoryId;

  @override
  int get hashCode => Object.hash(search, authorId, categoryId);

  static String? _stringOrNull(dynamic value) {
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }
}

class BookListState {
  BookListState({required Future<List<Book>> Function(int) fetchPage})
      : pagingController = PagingController<int, Book>(
          getNextPageKey: (state) {
            final pages = state.pages;
            if (pages == null || pages.isEmpty) return 1;
            if (pages.last.length < _pageSize) return null;
            return (state.keys?.last ?? 0) + 1;
          },
          fetchPage: fetchPage,
        ) {
    scrollController.addListener(_saveOffset);
  }

  static const _pageSize = 12;
  final PagingController<int, Book> pagingController;
  final ScrollController scrollController = ScrollController();
  double _offset = 0;
  Timer? _offsetDebounce;

  void _saveOffset() {
    if (!scrollController.hasClients) return;
    _offsetDebounce?.cancel();
    _offsetDebounce = Timer(const Duration(milliseconds: 150), () {
      if (scrollController.hasClients) _offset = scrollController.offset;
    });
  }

  void restoreOffset() {
    if (!scrollController.hasClients || _offset == 0) return;
    final max = scrollController.position.maxScrollExtent;
    scrollController.jumpTo(_offset.clamp(0, max).toDouble());
  }

  void dispose() {
    _offsetDebounce?.cancel();
    if (scrollController.hasClients) _offset = scrollController.offset;
    scrollController.dispose();
    pagingController.dispose();
  }
}

/// Keeps at most three inactive query controllers alive. Active controllers
/// remain alive until their listeners leave, so changing a filter cannot
/// dispose the list currently on screen.
class _BookListRetention {
  final LinkedHashMap<BookListKey, void Function()> _links = LinkedHashMap();

  void retain(BookListKey key, dynamic link) {
    _links.remove(key)?.call();
    _links[key] = () => link.close();
    while (_links.length > 3) {
      _links.remove(_links.keys.first)?.call();
    }
  }

  void remove(BookListKey key) => _links.remove(key);
}

final _bookListRetentionProvider = Provider((_) => _BookListRetention());

final bookListStateProvider =
    Provider.autoDispose.family<BookListState, BookListKey>((ref, key) {
  final api = ref.read(bookApiServiceProvider);
  final offline = ref.read(bookOfflineServiceProvider);
  final state = BookListState(
    fetchPage: (page) async {
      try {
        return await api.fetchBooks(
          page: page,
          perPage: BookListState._pageSize,
          search: key.search,
          authorId: key.authorId,
          categoryId: key.categoryId,
        );
      } catch (_) {
        return offline.queryBooks(page: page, perPage: BookListState._pageSize);
      }
    },
  );
  final keepAlive = ref.keepAlive();
  ref.read(_bookListRetentionProvider).retain(key, keepAlive);
  ref.onDispose(() {
    ref.read(_bookListRetentionProvider).remove(key);
    state.dispose();
  });
  return state;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/value_provider.dart';
import 'package:native_app/features/sura/models/ayah.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';

final searchQueryProvider = valueProvider<String>('');

class SearchPaginationState {
  final List<SearchResult> results;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;

  const SearchPaginationState({
    required this.results,
    required this.totalCount,
    required this.hasMore,
    required this.isLoadingMore,
  });

  SearchPaginationState copyWith({
    List<SearchResult>? results,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) => SearchPaginationState(
        results: results ?? this.results,
        totalCount: totalCount ?? this.totalCount,
        hasMore: hasMore ?? this.hasMore,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

class SearchNotifier
    extends AsyncNotifier<SearchPaginationState> {
  static const _pageSize = 20;

  List<String> _allKeys = [];
  Map<String, String> _translationMatches = {};

  @override
  Future<SearchPaginationState> build() async {
    final query = ref.watch(searchQueryProvider);
    _allKeys = [];
    _translationMatches = {};

    if (query.trim().isEmpty) {
      return const SearchPaginationState(
        results: [],
        totalCount: 0,
        hasMore: false,
        isLoadingMore: false,
      );
    }

    var cancelled = false;
    ref.onDispose(() => cancelled = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (cancelled) {
      return const SearchPaginationState(
        results: [],
        totalCount: 0,
        hasMore: false,
        isLoadingMore: false,
      );
    }

    final db = await ref.watch(databaseProvider.future);
    final service = ref.watch(quranDataServiceProvider);

    final (:keys, :translationMatches) =
        await service.searchQuranKeys(db, query);
    _allKeys = keys;
    _translationMatches = translationMatches;

    final firstPage = await service.fetchSearchResults(
      db,
      _allKeys,
      _translationMatches,
      offset: 0,
      limit: _pageSize,
    );

    return SearchPaginationState(
      results: firstPage,
      totalCount: _allKeys.length,
      hasMore: _allKeys.length > firstPage.length,
      isLoadingMore: false,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final db = await ref.read(databaseProvider.future);
    final service = ref.read(quranDataServiceProvider);

    final nextPage = await service.fetchSearchResults(
      db,
      _allKeys,
      _translationMatches,
      offset: current.results.length,
      limit: _pageSize,
    );

    final merged = [...current.results, ...nextPage];
    state = AsyncData(SearchPaginationState(
      results: merged,
      totalCount: current.totalCount,
      hasMore: merged.length < _allKeys.length,
      isLoadingMore: false,
    ));
  }
}

final searchNotifierProvider = AsyncNotifierProvider.autoDispose<SearchNotifier,
    SearchPaginationState>(SearchNotifier.new);

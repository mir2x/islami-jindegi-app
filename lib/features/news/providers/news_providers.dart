import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'news_api_service.dart';
import '../models/news.dart';

// ───────────────────── API Service ─────────────────────

final newsApiServiceProvider = Provider<NewsApiService>((ref) {
  return NewsApiService();
});

// ───────────────────── Query Params ─────────────────────

class NewsQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  NewsQueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final newsQueryParamsProvider =
    StateNotifierProvider<NewsQueryParamsNotifier, Map<String, dynamic>>((ref) {
  return NewsQueryParamsNotifier();
});

// ───────────────────── Latest News (home page) ─────────────────────

final latestNewsProvider =
    FutureProvider.autoDispose<List<NewsItem>>((ref) async {
  final api = ref.read(newsApiServiceProvider);
  return api.fetchNews(perPage: 5);
});

// ───────────────────── Single Item ─────────────────────

final singleNewsProvider =
    FutureProvider.autoDispose.family<NewsItem, String>((ref, id) async {
  final api = ref.read(newsApiServiceProvider);
  return api.fetchSingleNews(id);
});

// ───────────────────── Previous/Next navigation ─────────────────────

/// Cached ordered news IDs for previous/next navigation, mirroring
/// `bookNavigationIdsProvider`/`masailNavigationIdsProvider`. The .NET API
/// has no `gtPublishedAt`/`ltPublishedAt` adjacency query (unlike the old
/// Ruby `fetchNewsByGtPublishedAt`/`fetchNewsByLtPublishedAt`), so
/// previous/next is resolved by paging through the (published) list once —
/// in the API's default order (ascending by `position`) — and looking up
/// the current news item's index in that cache.
///
/// News has no offline cache (it's not in `offlineDbFeatures`), so unlike
/// book/masail there's no offline fallback here — a failed fetch just
/// leaves prev/next unavailable for this session.
final newsNavigationIdsProvider = FutureProvider<List<String>>((ref) async {
  final api = ref.read(newsApiServiceProvider);
  const perPage = 50;
  final ids = <String>[];

  try {
    int page = 1;
    while (true) {
      final items = await api.fetchNews(page: page, perPage: perPage);
      if (items.isEmpty) break;
      ids.addAll(items.map((item) => item.id));
      if (items.length < perPage) break;
      page++;
    }
  } catch (e) {
    debugPrint('[newsNavigationIdsProvider] API error: $e');
  }

  return ids;
});

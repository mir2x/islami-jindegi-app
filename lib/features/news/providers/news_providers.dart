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

// ───────────────────── Single Item ─────────────────────

final singleNewsProvider =
    FutureProvider.autoDispose.family<NewsItem, String>((ref, id) async {
  final api = ref.read(newsApiServiceProvider);
  return api.fetchSingleNews(id);
});

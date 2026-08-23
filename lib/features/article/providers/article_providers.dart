import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
import 'article_api_service.dart';
import 'article_offline_service.dart';
import '../models/article.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';
import 'article_progress_provider.dart';

// ───────────────────── Services ─────────────────────

final articleApiServiceProvider = Provider<ArticleApiService>((ref) {
  return ArticleApiService();
});

final articleOfflineServiceProvider = Provider<ArticleOfflineService>((ref) {
  return ArticleOfflineService();
});

// ───────────────────── Query Params ─────────────────────

class ArticleQueryParamsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {};

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final articleQueryParamsProvider =
    NotifierProvider<ArticleQueryParamsNotifier, Map<String, dynamic>>(
        ArticleQueryParamsNotifier.new,);

// ───────────────────── Single Item Providers ─────────────────────

final singleArticleProvider =
    FutureProvider.autoDispose.family<ArticleItem, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  final offline = ref.read(articleOfflineServiceProvider);
  try {
    return await api.fetchSingleArticle(id);
  } catch (error) {
    if (error is DioException && error.response?.statusCode == 404) {
      ref.read(articleProgressProvider.notifier).clear(id);
    }
    if (!shouldFallbackToOffline(error)) rethrow;
    final item = await offline.findArticleById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleArticleAuthorProvider =
    FutureProvider.autoDispose.family<ArticleAuthor, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  final offline = ref.read(articleOfflineServiceProvider);
  try {
    return await api.fetchAuthor(id);
  } catch (_) {
    final item = await offline.findAuthorById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleArticleCategoryProvider =
    FutureProvider.autoDispose.family<ArticleCategory, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  final offline = ref.read(articleOfflineServiceProvider);
  try {
    return await api.fetchCategory(id);
  } catch (_) {
    final item = await offline.findCategoryById(id);
    if (item != null) return item;
    rethrow;
  }
});

// ───────────────────── Retained list state ─────────────────────

final _articleListRegistryProvider = Provider((_) => RetainedListRegistry());
final articleListStateProvider = Provider.autoDispose
    .family<RetainedListState<ArticleItem>, RetainedListKey>((ref, key) {
  final api = ref.read(articleApiServiceProvider);
  final offline = ref.read(articleOfflineServiceProvider);
  final state = RetainedListState<ArticleItem>(
    pageSize: 9,
    fetch: (page) async {
      try {
        return await api.fetchArticles(
          page: page,
          perPage: 9,
          search: key.params['search'],
          articleAuthorId: key.params['articleAuthorId'],
          articleCategoryId: key.params['categoryId'],
          dateFrom: key.params['dateFrom'],
          dateTo: key.params['dateTo'],
        );
      } catch (_) {
        return offline.queryArticles(
          page: page,
          perPage: 9,
          search: key.params['search'],
          articleAuthorId: key.params['articleAuthorId'],
          articleCategoryId: key.params['categoryId'],
          dateFrom: key.params['dateFrom'],
          dateTo: key.params['dateTo'],
        );
      }
    },
  );
  final link = ref.keepAlive();
  ref.read(_articleListRegistryProvider).retain(key, link);
  ref.onDispose(() {
    ref.read(_articleListRegistryProvider).remove(key);
    state.dispose();
  });
  return state;
});

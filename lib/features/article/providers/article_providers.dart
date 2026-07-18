import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'article_api_service.dart';
import 'article_offline_service.dart';
import '../models/article.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';

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
        ArticleQueryParamsNotifier.new);

// ───────────────────── Single Item Providers ─────────────────────

final singleArticleProvider =
    FutureProvider.autoDispose.family<ArticleItem, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  final offline = ref.read(articleOfflineServiceProvider);
  try {
    return await api.fetchSingleArticle(id);
  } catch (_) {
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

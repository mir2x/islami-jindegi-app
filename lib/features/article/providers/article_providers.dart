import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'article_api_service.dart';
import 'article_offline_service.dart';
import '../models/article.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';
import '../models/article_subcategory.dart';

// ───────────────────── Services ─────────────────────

final articleApiServiceProvider = Provider<ArticleApiService>((ref) {
  return ArticleApiService();
});

final articleOfflineServiceProvider = Provider<ArticleOfflineService>((ref) {
  return ArticleOfflineService();
});

// ───────────────────── Query Params ─────────────────────

class ArticleQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  ArticleQueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final articleQueryParamsProvider =
    StateNotifierProvider<ArticleQueryParamsNotifier, Map<String, dynamic>>(
        (ref) {
  return ArticleQueryParamsNotifier();
});

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

final singleArticleSubcategoryProvider = FutureProvider.autoDispose
    .family<ArticleSubcategory, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  final offline = ref.read(articleOfflineServiceProvider);
  try {
    return await api.fetchSubcategory(id);
  } catch (_) {
    final item = await offline.findSubcategoryById(id);
    if (item != null) return item;
    rethrow;
  }
});

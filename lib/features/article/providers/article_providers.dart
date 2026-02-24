import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'article_api_service.dart';
import '../models/article.dart';
import '../models/article_author.dart';
import '../models/article_category.dart';
import '../models/article_subcategory.dart';

// ───────────────────── API Service ─────────────────────

final articleApiServiceProvider = Provider<ArticleApiService>((ref) {
  return ArticleApiService();
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
  return api.fetchSingleArticle(id);
});

final singleArticleAuthorProvider =
    FutureProvider.autoDispose.family<ArticleAuthor, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  return api.fetchAuthor(id);
});

final singleArticleCategoryProvider =
    FutureProvider.autoDispose.family<ArticleCategory, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  return api.fetchCategory(id);
});

final singleArticleSubcategoryProvider = FutureProvider.autoDispose
    .family<ArticleSubcategory, String>((ref, id) async {
  final api = ref.read(articleApiServiceProvider);
  return api.fetchSubcategory(id);
});

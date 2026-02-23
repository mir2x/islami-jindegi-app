import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'masail_api_service.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/masail_subcategory.dart';
import '../models/page_content.dart';

// ───────────────────── API Service ─────────────────────

final masailApiServiceProvider = Provider<MasailApiService>((ref) {
  return MasailApiService();
});

// ───────────────────── Query Params ─────────────────────

class MasailQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  MasailQueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final masailQueryParamsProvider =
    StateNotifierProvider<MasailQueryParamsNotifier, Map<String, dynamic>>(
        (ref) {
  return MasailQueryParamsNotifier();
});

// ───────────────────── Single Item Providers ─────────────────────

final singleMasailProvider =
    FutureProvider.autoDispose.family<MasailItem, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  return api.fetchSingleMasail(id);
});

final singleMasailAuthorProvider =
    FutureProvider.autoDispose.family<MasailAuthor, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  return api.fetchAuthor(id);
});

final singleMasailCategoryProvider =
    FutureProvider.autoDispose.family<MasailCategory, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  return api.fetchCategory(id);
});

final singleMasailSubcategoryProvider = FutureProvider.autoDispose
    .family<MasailSubcategory, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  return api.fetchSubcategory(id);
});

// ───────────────────── Pages (for ask-question) ─────────────────────

final askQuestionPageProvider =
    FutureProvider.autoDispose<PageContent?>((ref) async {
  final api = ref.read(masailApiServiceProvider);
  final pages = await api.fetchPages(slug: 'ask-masail', quantity: 1);
  return pages.isNotEmpty ? pages.first : null;
});

// ───────────────────── Settings (for ask-question FAB) ─────────────────────

final masailSettingsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final api = ref.read(masailApiServiceProvider);
  return api.fetchSettings();
});

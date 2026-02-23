import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'malfuzat_api_service.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';
import '../models/malfuzat_subcategory.dart';

// ───────────────────── API Service ─────────────────────

final malfuzatApiServiceProvider = Provider<MalfuzatApiService>((ref) {
  return MalfuzatApiService();
});

// ───────────────────── Query Params ─────────────────────

class MalfuzatQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  MalfuzatQueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final malfuzatQueryParamsProvider =
    StateNotifierProvider<MalfuzatQueryParamsNotifier, Map<String, dynamic>>(
        (ref) {
  return MalfuzatQueryParamsNotifier();
});

// ───────────────────── Single Item Providers ─────────────────────

final singleMalfuzatProvider =
    FutureProvider.autoDispose.family<MalfuzatItem, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  return api.fetchSingleMalfuzat(id);
});

final singleMalfuzatAuthorProvider =
    FutureProvider.autoDispose.family<MalfuzatAuthor, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  return api.fetchAuthor(id);
});

final singleMalfuzatCategoryProvider = FutureProvider.autoDispose
    .family<MalfuzatCategory, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  return api.fetchCategory(id);
});

final singleMalfuzatSubcategoryProvider = FutureProvider.autoDispose
    .family<MalfuzatSubcategory, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  return api.fetchSubcategory(id);
});

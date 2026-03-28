import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'malfuzat_api_service.dart';
import 'malfuzat_offline_service.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';
import '../models/malfuzat_subcategory.dart';

// ───────────────────── Services ─────────────────────

final malfuzatApiServiceProvider = Provider<MalfuzatApiService>((ref) {
  return MalfuzatApiService();
});

final malfuzatOfflineServiceProvider =
    Provider<MalfuzatOfflineService>((ref) {
  return MalfuzatOfflineService();
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
    StateNotifierProvider.autoDispose<MalfuzatQueryParamsNotifier,
        Map<String, dynamic>>((ref) {
  return MalfuzatQueryParamsNotifier();
});

// ───────────────────── Single Item Providers ─────────────────────

final singleMalfuzatProvider =
    FutureProvider.autoDispose.family<MalfuzatItem, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  final offline = ref.read(malfuzatOfflineServiceProvider);
  try {
    return await api.fetchSingleMalfuzat(id);
  } catch (_) {
    final item = await offline.findMalfuzatById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleMalfuzatAuthorProvider =
    FutureProvider.autoDispose.family<MalfuzatAuthor, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  final offline = ref.read(malfuzatOfflineServiceProvider);
  try {
    return await api.fetchAuthor(id);
  } catch (_) {
    final item = await offline.findAuthorById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleMalfuzatCategoryProvider = FutureProvider.autoDispose
    .family<MalfuzatCategory, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  final offline = ref.read(malfuzatOfflineServiceProvider);
  try {
    return await api.fetchCategory(id);
  } catch (_) {
    final item = await offline.findCategoryById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleMalfuzatSubcategoryProvider = FutureProvider.autoDispose
    .family<MalfuzatSubcategory, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  final offline = ref.read(malfuzatOfflineServiceProvider);
  try {
    return await api.fetchSubcategory(id);
  } catch (_) {
    final item = await offline.findSubcategoryById(id);
    if (item != null) return item;
    rethrow;
  }
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dua_api_service.dart';
import 'dua_offline_service.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

// ───────────────────── Services ─────────────────────

final duaApiServiceProvider = Provider<DuaApiService>((ref) {
  return DuaApiService();
});

final duaOfflineServiceProvider = Provider<DuaOfflineService>((ref) {
  return DuaOfflineService();
});

// ───────────────────── Query Params ─────────────────────

class DuaQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  DuaQueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final duaQueryParamsProvider =
    StateNotifierProvider.autoDispose<DuaQueryParamsNotifier,
        Map<String, dynamic>>((ref) {
  return DuaQueryParamsNotifier();
});

// ───────────────────── Single Item Providers ─────────────────────

final singleDuaProvider =
    FutureProvider.autoDispose.family<DuaItem, String>((ref, id) async {
  final api = ref.read(duaApiServiceProvider);
  final offline = ref.read(duaOfflineServiceProvider);
  try {
    return await api.fetchSingleDua(id);
  } catch (_) {
    final item = await offline.findDuaById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleDuaCategoryProvider =
    FutureProvider.autoDispose.family<DuaCategory, String>((ref, id) async {
  final api = ref.read(duaApiServiceProvider);
  final offline = ref.read(duaOfflineServiceProvider);
  try {
    return await api.fetchCategory(id);
  } catch (_) {
    final item = await offline.findCategoryById(id);
    if (item != null) return item;
    rethrow;
  }
});

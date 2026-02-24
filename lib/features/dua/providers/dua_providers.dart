import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dua_api_service.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

// ───────────────────── API Service ─────────────────────

final duaApiServiceProvider = Provider<DuaApiService>((ref) {
  return DuaApiService();
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
    StateNotifierProvider<DuaQueryParamsNotifier, Map<String, dynamic>>((ref) {
  return DuaQueryParamsNotifier();
});

// ───────────────────── All Duas (offline) ─────────────────────

final allDuasProvider = FutureProvider.autoDispose
    .family<List<DuaItem>, Map<String, dynamic>>((ref, params) async {
  final api = ref.read(duaApiServiceProvider);
  return api.fetchDuas(
    search: params['search'],
    duaCategoryId: params['duaCategoryId'],
  );
});

// ───────────────────── Single Item Providers ─────────────────────

final singleDuaProvider =
    FutureProvider.autoDispose.family<DuaItem, String>((ref, id) async {
  final api = ref.read(duaApiServiceProvider);
  return api.fetchSingleDua(id);
});

final singleDuaCategoryProvider =
    FutureProvider.autoDispose.family<DuaCategory, String>((ref, id) async {
  final api = ref.read(duaApiServiceProvider);
  return api.fetchCategory(id);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
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

// ───────────────────── Connectivity ─────────────────────

// ───────────────────── Query Params ─────────────────────

class DuaQueryParamsNotifier extends Notifier<Map<String, dynamic>> {
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

final duaQueryParamsProvider =
    NotifierProvider.autoDispose<DuaQueryParamsNotifier, Map<String, dynamic>>(
        DuaQueryParamsNotifier.new);

// ───────────────────── Single Item Providers ─────────────────────

final singleDuaProvider =
    FutureProvider.autoDispose.family<DuaItem, String>((ref, id) async {
  final api = ref.read(duaApiServiceProvider);
  final offline = ref.read(duaOfflineServiceProvider);
  try {
    return await api.fetchSingleDua(id);
  } catch (error) {
    if (!shouldFallbackToOffline(error)) rethrow;
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


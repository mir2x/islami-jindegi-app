import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import 'dua_api_service.dart';
import 'dua_offline_service.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';
import 'dua_progress_provider.dart';

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

final _duaListRegistryProvider = Provider((_) => RetainedListRegistry());
final duaListStateProvider = Provider.autoDispose
    .family<RetainedListState<DuaItem>, RetainedListKey>((ref, key) {
  final api = ref.read(duaApiServiceProvider);
  final offline = ref.read(duaOfflineServiceProvider);
  final state = RetainedListState<DuaItem>(
    pageSize: 20,
    fetch: (page) async {
      try {
        return await api.fetchDuas(
          page: page,
          perPage: 20,
          search: key.params['search'],
          categoryId: key.params['categoryId'],
        );
      } catch (_) {
        return offline.queryDuas(
          page: page,
          perPage: 20,
          search: key.params['search'],
          categoryId: key.params['categoryId'],
        );
      }
    },
  );
  final link = ref.keepAlive();
  ref.read(_duaListRegistryProvider).retain(key, link);
  ref.onDispose(() {
    ref.read(_duaListRegistryProvider).remove(key);
    state.dispose();
  });
  return state;
});

// ───────────────────── Single Item Providers ─────────────────────

final singleDuaProvider =
    FutureProvider.autoDispose.family<DuaItem, String>((ref, id) async {
  final api = ref.read(duaApiServiceProvider);
  final offline = ref.read(duaOfflineServiceProvider);
  try {
    return await api.fetchSingleDua(id);
  } catch (error) {
    if (error is DioException && error.response?.statusCode == 404)
      ref.read(duaProgressProvider.notifier).clear(id);
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

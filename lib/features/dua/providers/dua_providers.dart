import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

final _connectivityProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  return !result.contains(ConnectivityResult.none);
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

// ───────────────────── Previous/Next navigation ─────────────────────

/// Cached ordered dua IDs for previous/next navigation, mirroring
/// `masailNavigationIdsProvider`. The .NET API has no `position`/`quantity`
/// adjacency query (unlike the old JSON:API backend's `fetchDuasByPosition`),
/// so previous/next is resolved by paging through the (unfiltered, published)
/// list once and looking up the current dua's index in that cache.
final duaNavigationIdsProvider = FutureProvider<List<String>>((ref) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(duaApiServiceProvider);
  final offline = ref.read(duaOfflineServiceProvider);
  const perPage = 50;
  final ids = <String>[];

  if (isConnected) {
    try {
      int page = 1;
      while (true) {
        final items = await api.fetchDuas(page: page, perPage: perPage);
        if (items.isEmpty) break;
        ids.addAll(items.map((item) => item.id));
        if (items.length < perPage) break;
        page++;
      }
      return ids;
    } catch (e) {
      debugPrint('[duaNavigationIdsProvider] API error: $e');
    }
  }

  int page = 1;
  while (true) {
    final items = await offline.queryDuas(page: page, perPage: perPage);
    if (items.isEmpty) break;
    ids.addAll(items.map((item) => item.id));
    if (items.length < perPage) break;
    page++;
  }
  return ids;
});

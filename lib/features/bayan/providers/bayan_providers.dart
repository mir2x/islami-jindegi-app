import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'bayan_api_service.dart';
import 'bayan_offline_service.dart';
import '../models/bayan.dart';
import '../models/speaker.dart';
import '../models/bayan_category.dart';

// ───────────────────── Services ─────────────────────

final bayanApiServiceProvider = Provider<BayanApiService>((ref) {
  return BayanApiService();
});

final bayanOfflineServiceProvider = Provider<BayanOfflineService>((ref) {
  return BayanOfflineService();
});

// ───────────────────── Connectivity ─────────────────────

final _connectivityProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  return !result.contains(ConnectivityResult.none);
});

// ───────────────────── Query Params (module-specific) ─────────────────────
// Uses the same interface as the global QueryParamsNotifier
// so shared widgets (FilterItem, FilterList) work seamlessly.

class BayanQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  BayanQueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final bayanQueryParamsProvider =
    StateNotifierProvider.autoDispose<BayanQueryParamsNotifier,
        Map<String, dynamic>>((ref) {
  return BayanQueryParamsNotifier();
});

// ───────────────────── Navigation (prev/next) ─────────────────────

/// Cached ordered bayan IDs for previous/next navigation. The .NET API has
/// no server-side "item at position N" lookup (unlike the old JSON:API
/// backend's `fetchBayansByPosition`), so — matching the malfuzat/masail
/// module's `*NavigationIdsProvider` pattern — we fetch all published bayan
/// ids ordered by position once and navigate by index within that
/// in-memory list.
final bayanNavigationIdsProvider = FutureProvider<List<String>>((ref) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(bayanApiServiceProvider);
  final offline = ref.read(bayanOfflineServiceProvider);
  const perPage = 20;
  final ids = <String>[];

  if (isConnected) {
    try {
      int page = 1;
      while (true) {
        final items = await api.fetchBayans(page: page, perPage: perPage);
        if (items.isEmpty) break;
        ids.addAll(items.map((item) => item.id));
        if (items.length < perPage) break;
        page++;
      }
      return ids;
    } catch (e) {
      debugPrint('[bayanNavigationIdsProvider] API error: $e');
    }
  }

  int page = 1;
  while (true) {
    final items = await offline.queryBayans(page: page, perPage: perPage);
    if (items.isEmpty) break;
    ids.addAll(items.map((item) => item.id));
    if (items.length < perPage) break;
    page++;
  }
  return ids;
});

// ───────────────────── Single Bayan ─────────────────────

final singleBayanProvider =
    FutureProvider.autoDispose.family<Bayan, String>((ref, id) async {
  final api = ref.read(bayanApiServiceProvider);
  final offline = ref.read(bayanOfflineServiceProvider);
  try {
    return await api.fetchBayan(id);
  } catch (_) {
    final item = await offline.findBayanById(id);
    if (item != null) return item;
    rethrow;
  }
});

// ───────────────────── Single Speaker (for filter label) ─────────────────────

final singleSpeakerProvider =
    FutureProvider.autoDispose.family<Speaker, String>((ref, id) async {
  final api = ref.read(bayanApiServiceProvider);
  final offline = ref.read(bayanOfflineServiceProvider);
  try {
    return await api.fetchSpeaker(id);
  } catch (_) {
    final item = await offline.findSpeakerById(id);
    if (item != null) return item;
    rethrow;
  }
});

// ───────────────────── Single BayanCategory (for filter label) ─────────────────────

final singleBayanCategoryProvider =
    FutureProvider.autoDispose.family<BayanCategory, String>((ref, id) async {
  final api = ref.read(bayanApiServiceProvider);
  final offline = ref.read(bayanOfflineServiceProvider);
  try {
    return await api.fetchBayanCategory(id);
  } catch (_) {
    final item = await offline.findCategoryById(id);
    if (item != null) return item;
    rethrow;
  }
});

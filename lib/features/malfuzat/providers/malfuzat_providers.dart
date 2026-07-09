import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'malfuzat_api_service.dart';
import 'malfuzat_offline_service.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';

// ───────────────────── Services ─────────────────────

final malfuzatApiServiceProvider = Provider<MalfuzatApiService>((ref) {
  return MalfuzatApiService();
});

final malfuzatOfflineServiceProvider =
    Provider<MalfuzatOfflineService>((ref) {
  return MalfuzatOfflineService();
});

// ───────────────────── Connectivity ─────────────────────

final _connectivityProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  final isConnected = !result.contains(ConnectivityResult.none);
  debugPrint(
    '[MalfuzatProviders] Connectivity check: $isConnected (results: $result)',
  );
  return isConnected;
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

// ───────────────────── Navigation (prev/next) ─────────────────────

/// Cached ordered malfuzat IDs for previous/next navigation. The .NET API
/// has no server-side "item at position N" lookup (unlike the old JSON:API
/// backend), so — matching the book module's `bookNavigationIdsProvider`
/// pattern — we fetch all published malfuzat ids ordered by position once
/// and navigate by index within that in-memory list.
final malfuzatNavigationIdsProvider = FutureProvider<List<String>>((ref) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(malfuzatApiServiceProvider);
  final offline = ref.read(malfuzatOfflineServiceProvider);
  const perPage = 20;
  final ids = <String>[];

  if (isConnected) {
    try {
      int page = 1;
      while (true) {
        final items = await api.fetchMalfuzat(page: page, perPage: perPage);
        if (items.isEmpty) break;
        ids.addAll(items.map((item) => item.id));
        if (items.length < perPage) break;
        page++;
      }
      return ids;
    } catch (e) {
      debugPrint('[malfuzatNavigationIdsProvider] API error: $e');
    }
  }

  int page = 1;
  while (true) {
    final items = await offline.queryMalfuzats(page: page, perPage: perPage);
    if (items.isEmpty) break;
    ids.addAll(items.map((item) => item.id));
    if (items.length < perPage) break;
    page++;
  }
  return ids;
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

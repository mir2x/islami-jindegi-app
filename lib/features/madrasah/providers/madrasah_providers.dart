import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'madrasah_api_service.dart';
import 'madrasah_offline_service.dart';
import '../models/madrasah.dart';

// ───────────────────── Services ─────────────────────

final madrasahApiServiceProvider = Provider<MadrasahApiService>((ref) {
  return MadrasahApiService();
});

final madrasahOfflineServiceProvider =
    Provider<MadrasahOfflineService>((ref) {
  return MadrasahOfflineService();
});

// ───────────────────── Connectivity ─────────────────────

final _connectivityProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  return !result.contains(ConnectivityResult.none);
});

// ───────────────────── Query Params ─────────────────────

class MadrasahQueryParamsNotifier extends StateNotifier<Map<String, dynamic>> {
  MadrasahQueryParamsNotifier() : super({});

  void updateParams(String key, String value) {
    if (value.isNotEmpty) {
      state = {...state, key: value};
    } else {
      state = Map.from(state)..remove(key);
    }
  }
}

final madrasahQueryParamsProvider =
    StateNotifierProvider<MadrasahQueryParamsNotifier, Map<String, dynamic>>(
        (ref) {
  return MadrasahQueryParamsNotifier();
});

// ───────────────────── Single Item Provider ─────────────────────

/// Fetches a madrasah's full detail. Infos and photos are always nested in
/// the .NET API's response, so this single provider now backs the detail,
/// introduction, gallery and info screens — the old JSON:API version needed
/// separate `singleMadrasahProvider`/`singleMadrasahWithPhotosProvider`
/// variants keyed off `include=` query flags; the .NET detail has no such
/// split, so that duplication goes away.
final singleMadrasahProvider =
    FutureProvider.autoDispose.family<MadrasahItem, String>((ref, id) async {
  final api = ref.read(madrasahApiServiceProvider);
  final offline = ref.read(madrasahOfflineServiceProvider);
  try {
    return await api.fetchSingleMadrasah(id);
  } catch (_) {
    final item = await offline.findMadrasahById(id);
    if (item != null) return item;
    rethrow;
  }
});

// ───────────────────── Previous/Next navigation ─────────────────────

/// Cached ordered madrasah IDs for previous/next navigation, mirroring
/// `duaNavigationIdsProvider`/`bookNavigationIdsProvider`. The .NET API has
/// no `position`/`quantity` adjacency query (unlike the old JSON:API
/// backend's `fetchMadrasahsByPosition`), so previous/next between
/// madrasahs is resolved by paging through the (unfiltered) list once and
/// looking up the current madrasah's index in that cache.
final madrasahNavigationIdsProvider =
    FutureProvider<List<String>>((ref) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(madrasahApiServiceProvider);
  final offline = ref.read(madrasahOfflineServiceProvider);
  const perPage = 50;
  final ids = <String>[];

  if (isConnected) {
    try {
      int page = 1;
      while (true) {
        final items = await api.fetchMadrasahs(page: page, perPage: perPage);
        if (items.isEmpty) break;
        ids.addAll(items.map((item) => item.id));
        if (items.length < perPage) break;
        page++;
      }
      return ids;
    } catch (e) {
      debugPrint('[madrasahNavigationIdsProvider] API error: $e');
    }
  }

  int page = 1;
  while (true) {
    final items = await offline.queryMadrasahs(page: page, perPage: perPage);
    if (items.isEmpty) break;
    ids.addAll(items.map((item) => item.id));
    if (items.length < perPage) break;
    page++;
  }
  return ids;
});

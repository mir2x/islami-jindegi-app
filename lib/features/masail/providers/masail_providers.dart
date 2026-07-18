import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'masail_api_service.dart';
import 'masail_offline_service.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/page_content.dart';

// ───────────────────── Services ─────────────────────

final masailApiServiceProvider = Provider<MasailApiService>((ref) {
  return MasailApiService();
});

final masailOfflineServiceProvider = Provider<MasailOfflineService>((ref) {
  return MasailOfflineService();
});

// ───────────────────── Connectivity ─────────────────────

final _connectivityProvider = FutureProvider<bool>((ref) async {
  final result = await Connectivity().checkConnectivity();
  return !result.contains(ConnectivityResult.none);
});

// ───────────────────── Query Params ─────────────────────

class MasailQueryParamsNotifier extends Notifier<Map<String, dynamic>> {
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

final masailQueryParamsProvider =
    NotifierProvider.autoDispose<MasailQueryParamsNotifier,
        Map<String, dynamic>>(MasailQueryParamsNotifier.new);

// ───────────────────── Single Item Providers ─────────────────────

final singleMasailProvider =
    FutureProvider.autoDispose.family<MasailItem, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  try {
    return await api.fetchSingleMasail(id);
  } catch (_) {
    final item = await offline.findMasailById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleMasailAuthorProvider =
    FutureProvider.autoDispose.family<MasailAuthor, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  try {
    return await api.fetchAuthor(id);
  } catch (_) {
    final item = await offline.findAuthorById(id);
    if (item != null) return item;
    rethrow;
  }
});

final singleMasailCategoryProvider =
    FutureProvider.autoDispose.family<MasailCategory, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  try {
    return await api.fetchCategory(id);
  } catch (_) {
    final item = await offline.findCategoryById(id);
    if (item != null) return item;
    rethrow;
  }
});

// ───────────────────── Previous/Next navigation ─────────────────────

/// Cached ordered masail IDs for previous/next navigation, mirroring
/// `bookNavigationIdsProvider`. The .NET API has no `position`/`quantity`
/// adjacency query (unlike the old Ruby `fetchMasailByPosition`), so
/// previous/next is resolved by paging through the (unfiltered, published)
/// list once and looking up the current masail's index in that cache.
final masailNavigationIdsProvider = FutureProvider<List<String>>((ref) async {
  final isConnected = await ref.watch(_connectivityProvider.future);
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  const perPage = 50;
  final ids = <String>[];

  if (isConnected) {
    try {
      int page = 1;
      while (true) {
        final items = await api.fetchMasail(page: page, perPage: perPage);
        if (items.isEmpty) break;
        ids.addAll(items.map((item) => item.id));
        if (items.length < perPage) break;
        page++;
      }
      return ids;
    } catch (e) {
      debugPrint('[masailNavigationIdsProvider] API error: $e');
    }
  }

  int page = 1;
  while (true) {
    final items = await offline.queryMasails(page: page, perPage: perPage);
    if (items.isEmpty) break;
    ids.addAll(items.map((item) => item.id));
    if (items.length < perPage) break;
    page++;
  }
  return ids;
});

// ───────────────────── Pages (for ask-question) ─────────────────────

final askQuestionPageProvider =
    FutureProvider.autoDispose<PageContent?>((ref) async {
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  try {
    return await api.fetchPageBySlug('ask-masail');
  } catch (_) {
    return await offline.findPageBySlug('ask-masail');
  }
});

// ───────────────────── Settings (for ask-question FAB) ─────────────────────

final masailSettingsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final api = ref.read(masailApiServiceProvider);
  return api.fetchSettings();
});

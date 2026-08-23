import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import 'package:native_app/helpers/date_range_filter.dart';
import 'malfuzat_api_service.dart';
import 'malfuzat_offline_service.dart';
import '../models/malfuzat.dart';
import '../models/malfuzat_author.dart';
import '../models/malfuzat_category.dart';
import 'malfuzat_progress_provider.dart';

// ───────────────────── Services ─────────────────────

final malfuzatApiServiceProvider = Provider<MalfuzatApiService>((ref) {
  return MalfuzatApiService();
});

final malfuzatOfflineServiceProvider = Provider<MalfuzatOfflineService>((ref) {
  return MalfuzatOfflineService();
});

// ───────────────────── Connectivity ─────────────────────

// ───────────────────── Query Params ─────────────────────

class MalfuzatQueryParamsNotifier extends Notifier<Map<String, dynamic>> {
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

final malfuzatQueryParamsProvider = NotifierProvider.autoDispose<
    MalfuzatQueryParamsNotifier,
    Map<String, dynamic>>(MalfuzatQueryParamsNotifier.new);

final _malfuzatListRegistryProvider = Provider((_) => RetainedListRegistry());
final malfuzatListStateProvider = Provider.autoDispose
    .family<RetainedListState<MalfuzatItem>, RetainedListKey>((ref, key) {
  final api = ref.read(malfuzatApiServiceProvider);
  final offline = ref.read(malfuzatOfflineServiceProvider);
  final dates = DateRangeFilter.of(key.params);
  final hasAudio = key.params['hasAudio'] == 'true'
      ? true
      : key.params['hasAudio'] == 'false'
          ? false
          : null;
  final state = RetainedListState<MalfuzatItem>(
    pageSize: 9,
    fetch: (page) async {
      try {
        return await api.fetchMalfuzat(
            page: page,
            perPage: 9,
            search: key.params['search'],
            authorId: key.params['authorId'],
            categoryId: key.params['categoryId'],
            hasAudio: hasAudio,
            dateFrom: dates.from,
            dateTo: dates.to);
      } catch (_) {
        return offline.queryMalfuzats(
            page: page,
            perPage: 9,
            search: key.params['search'],
            authorId: key.params['authorId'],
            categoryId: key.params['categoryId'],
            hasAudio: hasAudio,
            dateFrom: dates.from,
            dateTo: dates.to);
      }
    },
  );
  final link = ref.keepAlive();
  ref.read(_malfuzatListRegistryProvider).retain(key, link);
  ref.onDispose(() {
    ref.read(_malfuzatListRegistryProvider).remove(key);
    state.dispose();
  });
  return state;
});

// ───────────────────── Single Item Providers ─────────────────────

final singleMalfuzatProvider =
    FutureProvider.autoDispose.family<MalfuzatItem, String>((ref, id) async {
  final api = ref.read(malfuzatApiServiceProvider);
  final offline = ref.read(malfuzatOfflineServiceProvider);
  try {
    return await api.fetchSingleMalfuzat(id);
  } catch (error) {
    if (error is DioException && error.response?.statusCode == 404) {
      ref.read(malfuzatProgressProvider.notifier).clear(id);
    }
    if (!shouldFallbackToOffline(error)) rethrow;
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

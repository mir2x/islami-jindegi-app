import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/navigation/content_scope.dart';
import 'package:dio/dio.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
import 'package:native_app/core/navigation/retained_list_state.dart';
import 'package:native_app/helpers/date_range_filter.dart';
import 'masail_api_service.dart';
import 'masail_offline_service.dart';
import '../models/masail.dart';
import '../models/masail_author.dart';
import '../models/masail_category.dart';
import '../models/page_content.dart';
import 'masail_progress_provider.dart';

// ───────────────────── Services ─────────────────────

final masailApiServiceProvider = Provider<MasailApiService>((ref) {
  return MasailApiService();
});

final masailOfflineServiceProvider = Provider<MasailOfflineService>((ref) {
  return MasailOfflineService();
});

// ───────────────────── Connectivity ─────────────────────

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

final masailQueryParamsProvider = NotifierProvider.autoDispose<
    MasailQueryParamsNotifier,
    Map<String, dynamic>>(MasailQueryParamsNotifier.new);

final _masailListRegistryProvider = Provider((_) => RetainedListRegistry());
final masailListStateProvider = Provider.autoDispose
    .family<RetainedListState<MasailItem>, RetainedListKey>((ref, key) {
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  final dates = DateRangeFilter.of(key.params);
  final hasAudio = key.params['hasAudio'] == 'true'
      ? true
      : key.params['hasAudio'] == 'false'
          ? false
          : null;
  final state = RetainedListState<MasailItem>(
    pageSize: 9,
    fetch: (page) async {
      try {
        return await api.fetchMasail(
            page: page,
            perPage: 9,
            search: key.params['search'],
            authorId: key.params['authorId'],
            categoryId: key.params['categoryId'],
            hasAudio: key.params['hasAudio'],
            dateFrom: dates.from,
            dateTo: dates.to);
      } catch (_) {
        return offline.queryMasails(
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
  ref.read(_masailListRegistryProvider).retain(key, link);
  ref.onDispose(() {
    ref.read(_masailListRegistryProvider).remove(key);
    state.dispose();
  });
  return state;
});

// ───────────────────── Single Item Providers ─────────────────────

/// Keyed on `(id, scope)` because the detail payload's `previous`/`next`
/// differ per Text/Audio tab — one cache entry per scope, not per item.
final singleMasailProvider = FutureProvider.autoDispose
    .family<MasailItem, ({String id, ContentScope scope})>((ref, arg) async {
  final id = arg.id;
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  try {
    return await api.fetchSingleMasail(id, scope: arg.scope);
  } catch (error) {
    if (error is DioException && error.response?.statusCode == 404) {
      ref.read(masailProgressProvider.notifier).clear(id);
    }
    if (!shouldFallbackToOffline(error)) rethrow;
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

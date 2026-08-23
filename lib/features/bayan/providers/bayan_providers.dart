import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
import 'bayan_api_service.dart';
import 'bayan_offline_service.dart';
import '../models/bayan.dart';
import '../models/speaker.dart';
import '../models/bayan_category.dart';
import 'bayan_progress_provider.dart';

// ───────────────────── Services ─────────────────────

final bayanApiServiceProvider = Provider<BayanApiService>((ref) {
  return BayanApiService();
});

final bayanOfflineServiceProvider = Provider<BayanOfflineService>((ref) {
  return BayanOfflineService();
});

// ───────────────────── Query Params (module-specific) ─────────────────────
// Uses the same interface as the global QueryParamsNotifier
// so shared widgets (FilterItem, FilterList) work seamlessly.

class BayanQueryParamsNotifier extends Notifier<Map<String, dynamic>> {
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

final bayanQueryParamsProvider = NotifierProvider.autoDispose<
    BayanQueryParamsNotifier,
    Map<String, dynamic>>(BayanQueryParamsNotifier.new);

// ───────────────────── Single Bayan ─────────────────────

final singleBayanProvider =
    FutureProvider.autoDispose.family<Bayan, String>((ref, id) async {
  final api = ref.read(bayanApiServiceProvider);
  final offline = ref.read(bayanOfflineServiceProvider);
  try {
    return await api.fetchBayan(id);
  } catch (error) {
    if (error is DioException && error.response?.statusCode == 404) {
      ref.read(bayanProgressProvider.notifier).clear(id);
    }
    if (!shouldFallbackToOffline(error)) rethrow;
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

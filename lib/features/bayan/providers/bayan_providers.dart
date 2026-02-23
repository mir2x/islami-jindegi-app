import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bayan_api_service.dart';
import '../models/bayan.dart';
import '../models/speaker.dart';
import '../models/bayan_category.dart';

// ───────────────────── API Service ─────────────────────

final bayanApiServiceProvider = Provider<BayanApiService>((ref) {
  return BayanApiService();
});

// ───────────────────── Query Params (module-specific) ─────────────────────
// Uses the same interface as the global QueryParamsNotifier
// so shared widgets (FilterItem, FilterList, DateFilter) work seamlessly.

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
    StateNotifierProvider<BayanQueryParamsNotifier, Map<String, dynamic>>(
        (ref) {
  return BayanQueryParamsNotifier();
});

// ───────────────────── Single Bayan ─────────────────────

final singleBayanProvider =
    FutureProvider.autoDispose.family<Bayan, String>((ref, id) async {
  final api = ref.read(bayanApiServiceProvider);
  return api.fetchBayan(id);
});

// ───────────────────── Single Speaker (for filter label) ─────────────────────

final singleSpeakerProvider =
    FutureProvider.autoDispose.family<Speaker, String>((ref, id) async {
  final api = ref.read(bayanApiServiceProvider);
  return api.fetchSpeaker(id);
});

// ───────────────────── Single BayanCategory (for filter label) ─────────────────────

final singleBayanCategoryProvider =
    FutureProvider.autoDispose.family<BayanCategory, String>((ref, id) async {
  final api = ref.read(bayanApiServiceProvider);
  return api.fetchBayanCategory(id);
});

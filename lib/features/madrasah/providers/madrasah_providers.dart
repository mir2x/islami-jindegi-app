import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
import 'madrasah_api_service.dart';
import 'madrasah_offline_service.dart';
import '../models/madrasah.dart';

// ───────────────────── Services ─────────────────────

final madrasahApiServiceProvider = Provider<MadrasahApiService>((ref) {
  return MadrasahApiService();
});

final madrasahOfflineServiceProvider = Provider<MadrasahOfflineService>((ref) {
  return MadrasahOfflineService();
});

// ───────────────────── Query Params ─────────────────────

class MadrasahQueryParamsNotifier extends Notifier<Map<String, dynamic>> {
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

final madrasahQueryParamsProvider =
    NotifierProvider<MadrasahQueryParamsNotifier, Map<String, dynamic>>(
        MadrasahQueryParamsNotifier.new);

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
  } catch (error) {
    if (!shouldFallbackToOffline(error)) rethrow;
    final item = await offline.findMadrasahById(id);
    if (item != null) return item;
    rethrow;
  }
});

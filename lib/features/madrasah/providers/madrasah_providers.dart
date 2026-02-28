import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'madrasah_api_service.dart';
import 'madrasah_offline_service.dart';
import '../models/madrasah.dart';
import '../models/madrasah_info.dart';

// ───────────────────── Services ─────────────────────

final madrasahApiServiceProvider = Provider<MadrasahApiService>((ref) {
  return MadrasahApiService();
});

final madrasahOfflineServiceProvider =
    Provider<MadrasahOfflineService>((ref) {
  return MadrasahOfflineService();
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

// ───────────────────── Single Item Providers ─────────────────────

final singleMadrasahProvider =
    FutureProvider.autoDispose.family<MadrasahItem, String>((ref, id) async {
  final api = ref.read(madrasahApiServiceProvider);
  final offline = ref.read(madrasahOfflineServiceProvider);
  try {
    return await api.fetchSingleMadrasah(id, includeInfos: true);
  } catch (_) {
    final item =
        await offline.findMadrasahById(id, includeInfos: true);
    if (item != null) return item;
    rethrow;
  }
});

final singleMadrasahWithPhotosProvider =
    FutureProvider.autoDispose.family<MadrasahItem, String>((ref, id) async {
  final api = ref.read(madrasahApiServiceProvider);
  final offline = ref.read(madrasahOfflineServiceProvider);
  try {
    return await api.fetchSingleMadrasah(id, includePhotos: true);
  } catch (_) {
    final item =
        await offline.findMadrasahById(id, includePhotos: true);
    if (item != null) return item;
    rethrow;
  }
});

final singleMadrasahInfoProvider = FutureProvider.autoDispose
    .family<MadrasahInfoItem, String>((ref, id) async {
  final api = ref.read(madrasahApiServiceProvider);
  final offline = ref.read(madrasahOfflineServiceProvider);
  try {
    return await api.fetchSingleInfo(id, includeMadrasah: true);
  } catch (_) {
    final item =
        await offline.findInfoById(id, includeMadrasah: true);
    if (item != null) return item;
    rethrow;
  }
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'madrasah_api_service.dart';
import '../models/madrasah.dart';
import '../models/madrasah_info.dart';

// ───────────────────── API Service ─────────────────────

final madrasahApiServiceProvider = Provider<MadrasahApiService>((ref) {
  return MadrasahApiService();
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
  return api.fetchSingleMadrasah(id, includeInfos: true);
});

final singleMadrasahWithPhotosProvider =
    FutureProvider.autoDispose.family<MadrasahItem, String>((ref, id) async {
  final api = ref.read(madrasahApiServiceProvider);
  return api.fetchSingleMadrasah(id, includePhotos: true);
});

final singleMadrasahInfoProvider = FutureProvider.autoDispose
    .family<MadrasahInfoItem, String>((ref, id) async {
  final api = ref.read(madrasahApiServiceProvider);
  return api.fetchSingleInfo(id, includeMadrasah: true);
});

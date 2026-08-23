import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/navigation/offline_fallback.dart';
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

// ───────────────────── Single Item Providers ─────────────────────

final singleMasailProvider =
    FutureProvider.autoDispose.family<MasailItem, String>((ref, id) async {
  final api = ref.read(masailApiServiceProvider);
  final offline = ref.read(masailOfflineServiceProvider);
  try {
    return await api.fetchSingleMasail(id);
  } catch (error) {
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

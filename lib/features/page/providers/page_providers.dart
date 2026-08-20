import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'page_api_service.dart';
import 'page_offline_service.dart';
import '../models/page_item.dart';

final pageApiServiceProvider = Provider<PageApiService>((ref) {
  return PageApiService();
});

final pageOfflineServiceProvider = Provider<PageOfflineService>((ref) {
  return PageOfflineService();
});

/// Network first, local offline copy second — the same shape as
/// `singleMasailProvider` / `askQuestionPageProvider` in the masail module.
///
/// The fallback only fires for slugs the admin flagged offline-available (so
/// a synced row exists); anything else rethrows, keeping a genuine 404 a 404
/// rather than dressing a missing page up as a network problem.
final pageBySlugProvider = FutureProvider.autoDispose
    .family<PageItem, String>((ref, slug) async {
  final api = ref.read(pageApiServiceProvider);
  final offline = ref.read(pageOfflineServiceProvider);
  try {
    return await api.fetchBySlug(slug);
  } catch (_) {
    final item = await offline.findBySlug(slug);
    if (item != null) return item;
    rethrow;
  }
});

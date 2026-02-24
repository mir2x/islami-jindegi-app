import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'namaz_time_api_service.dart';
import '../models/namaz_time.dart';

// ───────────────────── API Service ─────────────────────

final namazTimeApiServiceProvider = Provider<NamazTimeApiService>((ref) {
  return NamazTimeApiService();
});

// ───────────────────── Fetch By Slug ─────────────────────

final namazTimeBySlugProvider = FutureProvider.autoDispose
    .family<List<NamazTimeItem>, String>((ref, slug) async {
  final api = ref.read(namazTimeApiServiceProvider);
  return api.fetchBySlug(slug);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'page_api_service.dart';
import '../models/page_item.dart';

final pageApiServiceProvider = Provider<PageApiService>((ref) {
  return PageApiService();
});

final pageBySlugProvider = FutureProvider.autoDispose
    .family<List<PageItem>, String>((ref, slug) async {
  final api = ref.read(pageApiServiceProvider);
  return api.fetchBySlug(slug);
});

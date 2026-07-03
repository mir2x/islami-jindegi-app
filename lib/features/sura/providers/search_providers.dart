import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/features/sura/models/ayah.dart';
import 'package:native_app/features/sura/providers/sura_providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<SearchResultPage>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.trim().isEmpty) {
    return const SearchResultPage(results: [], totalCount: 0);
  }

  // Debounce: if the provider is disposed before the delay completes (because
  // the user kept typing), bail out instead of issuing a stale query.
  var cancelled = false;
  ref.onDispose(() => cancelled = true);

  await Future.delayed(const Duration(milliseconds: 300));
  if (cancelled) return const SearchResultPage(results: [], totalCount: 0);

  final db = await ref.watch(databaseProvider.future);
  final quranService = ref.watch(quranDataServiceProvider);

  return quranService.searchQuran(db, query);
});

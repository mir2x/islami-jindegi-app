import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'namaz_time_api_service.dart';
import '../models/namaz_time.dart';

// ───────────────────── API Service ─────────────────────

final namazTimeApiServiceProvider = Provider<NamazTimeApiService>((ref) {
  return NamazTimeApiService();
});

// ───────────────────── Static slug order ─────────────────────

/// Fixed order of the namaz-time content slugs, matching the fixed
/// `position` order (1..10) returned by the .NET API. This mirrors the
/// prayer-key -> slug mapping in `views/namaz_time_items.dart` (the *live*
/// prayer-time screen — out of scope for this migration, but the source of
/// truth for which slugs exist and in what order).
///
/// The .NET `NamazTimeListItem`/`NamazTimeDetail` DTOs have no `slug` field
/// at all (only `Title`/`TitleBn`/`Position`), unlike the legacy Ruby API.
/// Since there are only ~10 fixed prayer-period entries in a fixed order,
/// this static list + the cached full list (`namazTimeListProvider`) stand
/// in for the old `?slug=` query param: `namazTimeSlugOrder.indexOf(slug)`
/// gives the index into the position-ordered list.
const List<String> namazTimeSlugOrder = [
  'tahajjud',
  'fajr',
  'sunrise',
  'ishraq',
  'midday',
  'zuhr',
  'asr',
  'sunset',
  'maghrib',
  'isha',
];

// ───────────────────── Full list (cached) ─────────────────────

/// Fetches the full namaz-time list once (small, fixed size), ordered by
/// position. Used to resolve slug -> id and to drive prev/next navigation.
final namazTimeListProvider =
    FutureProvider<List<NamazTimeListItem>>((ref) async {
  final api = ref.read(namazTimeApiServiceProvider);
  return api.fetchAll();
});

// ───────────────────── Fetch By Slug ─────────────────────

/// Resolves a route slug (e.g. `fajr`) to its full detail (masail/fazail
/// text), or `null` if the slug is unknown / out of range.
final namazTimeBySlugProvider = FutureProvider.autoDispose
    .family<NamazTimeItem?, String>((ref, slug) async {
  final api = ref.read(namazTimeApiServiceProvider);
  final list = await ref.watch(namazTimeListProvider.future);
  final index = namazTimeSlugOrder.indexOf(slug);
  if (index < 0 || index >= list.length) return null;
  return api.fetchById(list[index].id);
});

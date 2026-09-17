import 'package:flutter/foundation.dart';
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
/// The API resolves these directly via `/namaz-times/by-slug/{slug}`. The
/// title matching below (see [namazTimeTitles]) and this order are fallbacks
/// for an API build that predates the slug column, so a server-side rename or
/// reorder degrades loudly instead of silently routing a prayer page to the
/// wrong content.
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

/// Known English and Bengali titles per slug. The live data mostly carries
/// English titles, but at least one row (tahajjud) is titled in Bengali only,
/// so both columns are consulted.
const Map<String, List<String>> namazTimeTitles = {
  'tahajjud': ['tahajjud', 'তাহাজ্জুদ'],
  'fajr': ['fajr', 'ফজর'],
  'sunrise': ['sunrise', 'সূর্যোদয়'],
  'ishraq': ['ishraq', 'ইশরাক'],
  'midday': ['midday', 'দ্বিপ্রহর'],
  'zuhr': ['zuhr', 'dhuhr', 'যুহর', 'জোহর'],
  'asr': ['asr', 'আসর'],
  'sunset': ['sunset', 'সূর্যাস্ত'],
  'maghrib': ['maghrib', 'মাগরিব'],
  'isha': ['isha', 'ইশা', 'এশা'],
};

/// Picks the row for [slug]: by the row's own slug when the API sends one,
/// else by English or Bengali title, else by the fixed position order. Logs when the list is not the
/// expected ten rows or when it had to fall back to the index, since either
/// means the server data drifted from what this mapping assumes.
NamazTimeListItem? resolveNamazTimeRow(
    List<NamazTimeListItem> list, String slug) {
  if (list.length != namazTimeSlugOrder.length) {
    debugPrint('[namaz-times] expected ${namazTimeSlugOrder.length} rows, '
        'got ${list.length}; slug resolution may be wrong');
  }
  for (final row in list) {
    if (row.slug == slug) return row;
  }
  final wanted = namazTimeTitles[slug] ?? [slug];
  for (final row in list) {
    final en = row.title.trim().toLowerCase();
    final bn = row.titleBn?.trim().toLowerCase();
    if (wanted.contains(en) || (bn != null && wanted.contains(bn))) {
      return row;
    }
  }
  final index = namazTimeSlugOrder.indexOf(slug);
  if (index < 0 || index >= list.length) return null;
  debugPrint('[namaz-times] no title matched "$slug"; '
      'falling back to position index $index');
  return list[index];
}

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
  final direct = await api.fetchBySlug(slug);
  if (direct != null) return direct;
  // Older API without slugs: fall back to matching the cached list.
  final list = await ref.watch(namazTimeListProvider.future);
  final row = resolveNamazTimeRow(list, slug);
  if (row == null) return null;
  return api.fetchById(row.id);
});

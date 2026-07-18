import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/bayan/models/downloaded_bayan.dart';

const _storageKey = 'downloaded_bayans_store';

Future<List<DownloadedBayan>> _loadAll() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_storageKey) ?? [];
  return raw.map((e) => DownloadedBayan.fromJson(jsonDecode(e))).toList();
}

Future<void> _saveAll(List<DownloadedBayan> items) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    _storageKey,
    items.map((e) => jsonEncode(e.toJson())).toList(),
  );
}

int _nextId(List<DownloadedBayan> items) {
  if (items.isEmpty) return 1;
  return items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
}

final getDownloadedBayanProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final items = await _loadAll();
  return items.cast<DownloadedBayan?>().firstWhere(
        (b) => b?.id == id,
        orElse: () => null,
      );
});

final getDownloadedBayanByIdProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String bayanId) async {
  final items = await _loadAll();
  return items.cast<DownloadedBayan?>().firstWhere(
        (b) => b?.bayanId == bayanId,
        orElse: () => null,
      );
});

final createDownloadedBayanProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final items = await _loadAll();
  final newResource = DownloadedBayan(
    id: _nextId(items),
    bayanId: attrs['bayanId'],
    title: attrs['title'],
    excerpt: attrs['excerpt'],
    location: attrs['location'],
    audio: attrs['audio'],
    speaker: attrs['speaker'],
    publishedAt: attrs['publishedAt'],
  );

  // Remove existing with same bayanId (upsert behavior)
  items.removeWhere((b) => b.bayanId == newResource.bayanId);
  items.add(newResource);
  await _saveAll(items);
});

final deleteDownloadedBayanProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String bayanId) async {
  final items = await _loadAll();
  items.removeWhere((b) => b.bayanId == bayanId);
  await _saveAll(items);
});

class DownloadedBayansNotifier extends AsyncNotifier<List> {
  @override
  Future<List> build() async {
    final items = await _loadAll();
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    return items;
  }

  Future<dynamic> deleteItem(bayanId) async {
    final items = await _loadAll();
    items.removeWhere((b) => b.bayanId == bayanId);
    await _saveAll(items);
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    state = AsyncValue.data(items);
  }
}

final downloadedBayansProvider =
    AsyncNotifierProvider.autoDispose<DownloadedBayansNotifier, List>(() {
  return DownloadedBayansNotifier();
});

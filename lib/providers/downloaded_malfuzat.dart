import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/malfuzat/models/downloaded_malfuzat.dart';

const _storageKey = 'downloaded_malfuzat_store';

Future<List<DownloadedMalfuzat>> _loadAll() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_storageKey) ?? [];
  return raw.map((e) => DownloadedMalfuzat.fromJson(jsonDecode(e))).toList();
}

Future<void> _saveAll(List<DownloadedMalfuzat> items) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    _storageKey,
    items.map((e) => jsonEncode(e.toJson())).toList(),
  );
}

int _nextId(List<DownloadedMalfuzat> items) {
  if (items.isEmpty) return 1;
  return items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
}

final getDownloadedMalfuzatProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final items = await _loadAll();
  return items.cast<DownloadedMalfuzat?>().firstWhere(
        (b) => b?.id == id,
        orElse: () => null,
      );
});

final getDownloadedMalfuzatByIdProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String malfuzatId) async {
  final items = await _loadAll();
  return items.cast<DownloadedMalfuzat?>().firstWhere(
        (b) => b?.malfuzatId == malfuzatId,
        orElse: () => null,
      );
});

final createDownloadedMalfuzatProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final items = await _loadAll();
  final newResource = DownloadedMalfuzat(
    id: _nextId(items),
    malfuzatId: attrs['malfuzatId'],
    title: attrs['title'],
    body: attrs['body'],
    excerpt: attrs['excerpt'],
    audio: attrs['audio'],
    document: attrs['document'],
    author: attrs['author'],
    publishedAt: attrs['publishedAt'],
  );

  items.removeWhere((b) => b.malfuzatId == newResource.malfuzatId);
  items.add(newResource);
  await _saveAll(items);
});

final deleteDownloadedMalfuzatProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String malfuzatId) async {
  final items = await _loadAll();
  items.removeWhere((b) => b.malfuzatId == malfuzatId);
  await _saveAll(items);
});

class DownloadedMalfuzatNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final items = await _loadAll();
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    return items;
  }

  Future<dynamic> deleteItem(malfuzatId) async {
    final items = await _loadAll();
    items.removeWhere((b) => b.malfuzatId == malfuzatId);
    await _saveAll(items);
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    state = AsyncValue.data(items);
  }
}

final downloadedMalfuzatProvider =
    AsyncNotifierProvider.autoDispose<DownloadedMalfuzatNotifier, List>(() {
  return DownloadedMalfuzatNotifier();
});

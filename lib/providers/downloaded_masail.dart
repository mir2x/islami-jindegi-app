import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:native_app/features/masail/models/downloaded_masail.dart';

const _storageKey = 'downloaded_masail_store';

Future<List<DownloadedMasail>> _loadAll() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_storageKey) ?? [];
  return raw.map((e) => DownloadedMasail.fromJson(jsonDecode(e))).toList();
}

Future<void> _saveAll(List<DownloadedMasail> items) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
    _storageKey,
    items.map((e) => jsonEncode(e.toJson())).toList(),
  );
}

int _nextId(List<DownloadedMasail> items) {
  if (items.isEmpty) return 1;
  return items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
}

final getDownloadedMasailProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final items = await _loadAll();
  return items.cast<DownloadedMasail?>().firstWhere(
        (b) => b?.id == id,
        orElse: () => null,
      );
});

final getDownloadedMasailByIdProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String masailId) async {
  final items = await _loadAll();
  return items.cast<DownloadedMasail?>().firstWhere(
        (b) => b?.masailId == masailId,
        orElse: () => null,
      );
});

final createDownloadedMasailProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final items = await _loadAll();
  final newResource = DownloadedMasail(
    id: _nextId(items),
    masailId: attrs['masailId'],
    title: attrs['title'],
    question: attrs['question'],
    answer: attrs['answer'],
    audio: attrs['audio'],
    document: attrs['document'],
    author: attrs['author'],
    publishedAt: attrs['publishedAt'],
  );

  items.removeWhere((b) => b.masailId == newResource.masailId);
  items.add(newResource);
  await _saveAll(items);
});

final deleteDownloadedMasailProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String masailId) async {
  final items = await _loadAll();
  items.removeWhere((b) => b.masailId == masailId);
  await _saveAll(items);
});

class DownloadedMasailNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final items = await _loadAll();
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    return items;
  }

  Future<dynamic> deleteItem(masailId) async {
    final items = await _loadAll();
    items.removeWhere((b) => b.masailId == masailId);
    await _saveAll(items);
    items.sort((a, b) => (b.publishedAt ?? '').compareTo(a.publishedAt ?? ''));
    state = AsyncValue.data(items);
  }
}

final downloadedMasailProvider =
    AsyncNotifierProvider.autoDispose<DownloadedMasailNotifier, List>(() {
  return DownloadedMasailNotifier();
});

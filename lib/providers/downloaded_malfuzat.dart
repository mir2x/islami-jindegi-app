import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_app/models/downloaded_malfuzat.dart';

final downloadedMalfuzatStoreProvider = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return Isar.getInstance('downloadedMalfuzats') ??
      await Isar.open(
        [DownloadedMalfuzatSchema],
        directory: dir.path,
        name: 'downloadedMalfuzats',
      );
});

final getDownloadedMalfuzatProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final isar = await ref.watch(downloadedMalfuzatStoreProvider.future);
  return await isar.downloadedMalfuzats.get(id);
});

final getDownloadedMalfuzatByIdProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String malfuzatId) async {
  final isar = await ref.watch(downloadedMalfuzatStoreProvider.future);
  return await isar.downloadedMalfuzats
      .where()
      .malfuzatIdEqualTo(malfuzatId)
      .findFirst();
});

final createDownloadedMalfuzatProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final isar = await ref.watch(downloadedMalfuzatStoreProvider.future);

  var newResource = DownloadedMalfuzat()
    ..malfuzatId = attrs['malfuzatId']
    ..title = attrs['title']
    ..body = attrs['body']
    ..excerpt = attrs['excerpt']
    ..audio = attrs['audio']
    ..document = attrs['document']
    ..author = attrs['author']
    ..publishedAt = attrs['publishedAt'];

  return await isar.writeTxn(() async {
    await isar.downloadedMalfuzats.put(newResource);
  });
});

final deleteDownloadedMalfuzatProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String malfuzatId) async {
  final isar = await ref.watch(downloadedMalfuzatStoreProvider.future);

  final resource = await isar.downloadedMalfuzats
      .where()
      .malfuzatIdEqualTo(malfuzatId)
      .findFirst();

  if (resource != null) {
    return await isar.writeTxn(() async {
      await isar.downloadedMalfuzats.delete(resource.id);
    });
  }
});

class DownloadedMalfuzatNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.watch(downloadedMalfuzatStoreProvider.future);
    var allResources = await isar.downloadedMalfuzats
        .where()
        .sortByPublishedAtDesc()
        .findAll();
    return allResources;
  }

  Future<dynamic> deleteItem(malfuzatId) async {
    final isar = await ref.watch(downloadedMalfuzatStoreProvider.future);

    final resource = await isar.downloadedMalfuzats
        .where()
        .malfuzatIdEqualTo(malfuzatId)
        .findFirst();

    if (resource != null) {
      await isar.writeTxn(() async {
        await isar.downloadedMalfuzats.delete(resource.id);
      });

      state = AsyncValue.data(
        await isar.downloadedMalfuzats
            .where()
            .sortByPublishedAtDesc()
            .findAll(),
      );
    }
  }
}

final downloadedMalfuzatProvider =
    AsyncNotifierProvider.autoDispose<DownloadedMalfuzatNotifier, List>(() {
  return DownloadedMalfuzatNotifier();
});

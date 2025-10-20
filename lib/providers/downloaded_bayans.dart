import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_app/models/downloaded_bayan.dart';

final downloadedBayansStoreProvider = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return Isar.getInstance('downloadedBayans') ??
      await Isar.open(
        [DownloadedBayanSchema],
        directory: dir.path,
        name: 'downloadedBayans',
      );
});

final getDownloadedBayanProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final isar = await ref.watch(downloadedBayansStoreProvider.future);
  return await isar.downloadedBayans.get(id);
});

final getDownloadedBayanByIdProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String bayanId) async {
  final isar = await ref.watch(downloadedBayansStoreProvider.future);
  return await isar.downloadedBayans
      .where()
      .bayanIdEqualTo(bayanId)
      .findFirst();
});

final createDownloadedBayanProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final isar = await ref.watch(downloadedBayansStoreProvider.future);

  var newResource = DownloadedBayan()
    ..bayanId = attrs['bayanId']
    ..title = attrs['title']
    ..excerpt = attrs['excerpt']
    ..location = attrs['location']
    ..audio = attrs['audio']
    ..speaker = attrs['speaker']
    ..publishedAt = attrs['publishedAt'];

  return await isar.writeTxn(() async {
    await isar.downloadedBayans.put(newResource);
  });
});

final deleteDownloadedBayanProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String bayanId) async {
  final isar = await ref.watch(downloadedBayansStoreProvider.future);

  final resource =
      await isar.downloadedBayans.where().bayanIdEqualTo(bayanId).findFirst();

  if (resource != null) {
    return await isar.writeTxn(() async {
      await isar.downloadedBayans.delete(resource.id);
    });
  }
});

class DownloadedBayansNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.watch(downloadedBayansStoreProvider.future);
    var allResources =
        await isar.downloadedBayans.where().sortByPublishedAtDesc().findAll();
    return allResources;
  }

  Future<dynamic> deleteItem(bayanId) async {
    final isar = await ref.watch(downloadedBayansStoreProvider.future);

    final resource =
        await isar.downloadedBayans.where().bayanIdEqualTo(bayanId).findFirst();

    if (resource != null) {
      await isar.writeTxn(() async {
        await isar.downloadedBayans.delete(resource.id);
      });

      state = AsyncValue.data(
        await isar.downloadedBayans.where().sortByPublishedAtDesc().findAll(),
      );
    }
  }
}

final downloadedBayansProvider =
    AsyncNotifierProvider.autoDispose<DownloadedBayansNotifier, List>(() {
  return DownloadedBayansNotifier();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_app/models/downloaded_masail.dart';

final downloadedMasailStoreProvider = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return Isar.getInstance('downloadedMasails') ??
      await Isar.open(
        [DownloadedMasailSchema],
        directory: dir.path,
        name: 'downloadedMasails',
      );
});

final getDownloadedMasailProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final isar = await ref.watch(downloadedMasailStoreProvider.future);
  return await isar.downloadedMasails.get(id);
});

final createDownloadedMasailProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final isar = await ref.watch(downloadedMasailStoreProvider.future);

  var newResource = DownloadedMasail()
    ..masailId = attrs['masailId']
    ..title = attrs['title']
    ..question = attrs['question']
    ..answer = attrs['answer']
    ..audio = attrs['audio']
    ..document = attrs['document']
    ..author = attrs['author']
    ..publishedAt = attrs['publishedAt'];

  return await isar.writeTxn(() async {
    await isar.downloadedMasails.put(newResource);
  });
});

final deleteDownloadedMasailProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String masailId) async {
  final isar = await ref.watch(downloadedMasailStoreProvider.future);

  final resource = await isar.downloadedMasails
      .where()
      .masailIdEqualTo(masailId)
      .findFirst();

  if (resource != null) {
    return await isar.writeTxn(() async {
      await isar.downloadedMasails.delete(resource.id);
    });
  }
});

class DownloadedMasailNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.watch(downloadedMasailStoreProvider.future);
    var allResources =
        await isar.downloadedMasails.where().sortByPublishedAtDesc().findAll();
    return allResources;
  }

  Future<dynamic> deleteItem(masailId) async {
    final isar = await ref.watch(downloadedMasailStoreProvider.future);

    final resource = await isar.downloadedMasails
        .where()
        .masailIdEqualTo(masailId)
        .findFirst();

    if (resource != null) {
      await isar.writeTxn(() async {
        await isar.downloadedMasails.delete(resource.id);
      });

      state = AsyncValue.data(
        await isar.downloadedMasails.where().sortByPublishedAtDesc().findAll(),
      );
    }
  }
}

final downloadedMasailProvider =
    AsyncNotifierProvider.autoDispose<DownloadedMasailNotifier, List>(() {
  return DownloadedMasailNotifier();
});

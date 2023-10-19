import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
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

class DownloadedBayanNotifier
    extends AutoDisposeAsyncNotifier<DownloadedBayan?> {
  @override
  Future<DownloadedBayan?> build() async {
    return null;
  }

  Future<dynamic> createItem(Map attrs) async {
    final isar = await ref.watch(downloadedBayansStoreProvider.future);

    var newResource = DownloadedBayan()
      ..bayanId = attrs['bayanId']
      ..link = attrs['link']
      ..title = attrs['title']
      ..speaker = attrs['speaker']
      ..audioFile = attrs['audioFile']
      ..publishedAt = attrs['publishedAt'];

    await isar.writeTxn(() async {
      await isar.downloadedBayans.put(newResource);
    });

    final createdResource = await isar.downloadedBayans
        .where()
        .bayanIdEqualTo(newResource.bayanId)
        .findFirst();
    state = AsyncValue.data(createdResource);
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.watch(downloadedBayansStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.downloadedBayans.delete(id);
    });

    final deletedResource = await isar.downloadedBayans.get(id);
    state = AsyncValue.data(deletedResource);
  }
}

final downloadedBayanProvider = AsyncNotifierProvider.autoDispose<
    DownloadedBayanNotifier, DownloadedBayan?>(
  DownloadedBayanNotifier.new,
);

class DownloadedBayansNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.watch(downloadedBayansStoreProvider.future);
    var allResources =
        await isar.downloadedBayans.where().sortByPublishedAtDesc().findAll();
    return allResources;
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.watch(downloadedBayansStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.downloadedBayans.delete(id);
    });

    state = AsyncValue.data(
      await isar.downloadedBayans.where().sortByPublishedAtDesc().findAll(),
    );
  }
}

final downloadedBayansProvider =
    AsyncNotifierProvider.autoDispose<DownloadedBayansNotifier, List>(() {
  return DownloadedBayansNotifier();
});

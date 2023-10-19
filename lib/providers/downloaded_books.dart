import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_app/models/downloaded_book.dart';

final downloadedBooksStoreProvider = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return Isar.getInstance('downloadedBooks') ??
      await Isar.open(
        [DownloadedBookSchema],
        directory: dir.path,
        name: 'downloadedBooks',
      );
});

class DownloadedBookNotifier extends AutoDisposeAsyncNotifier<DownloadedBook?> {
  @override
  Future<DownloadedBook?> build() async {
    return null;
  }

  Future<dynamic> createItem(Map attrs) async {
    final isar = await ref.watch(downloadedBooksStoreProvider.future);

    var newResource = DownloadedBook()
      ..bookId = attrs['bookId']
      ..link = attrs['link']
      ..title = attrs['title']
      ..author = attrs['author']
      ..documentFile = attrs['documentFile']
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.downloadedBooks.put(newResource);
    });

    final createdResource = await isar.downloadedBooks
        .where()
        .bookIdEqualTo(newResource.bookId)
        .findFirst();
    state = AsyncValue.data(createdResource);
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.watch(downloadedBooksStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.downloadedBooks.delete(id);
    });

    final deletedResource = await isar.downloadedBooks.get(id);
    state = AsyncValue.data(deletedResource);
  }
}

final downloadedBookProvider =
    AsyncNotifierProvider.autoDispose<DownloadedBookNotifier, DownloadedBook?>(
  DownloadedBookNotifier.new,
);

class DownloadedBooksNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.watch(downloadedBooksStoreProvider.future);
    var allResources =
        await isar.downloadedBooks.where().sortByCreatedAtDesc().findAll();
    return allResources;
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.watch(downloadedBooksStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.downloadedBooks.delete(id);
    });

    state = AsyncValue.data(
      await isar.downloadedBooks.where().sortByCreatedAtDesc().findAll(),
    );
  }
}

final downloadedBooksProvider =
    AsyncNotifierProvider.autoDispose<DownloadedBooksNotifier, List>(() {
  return DownloadedBooksNotifier();
});

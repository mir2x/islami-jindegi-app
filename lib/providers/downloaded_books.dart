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

final getDownloadedBookProvider =
    FutureProvider.autoDispose.family<dynamic, int>((ref, int id) async {
  final isar = await ref.watch(downloadedBooksStoreProvider.future);
  return await isar.downloadedBooks.get(id);
});

final createDownloadedBookProvider =
    FutureProvider.autoDispose.family<dynamic, Map>((ref, Map attrs) async {
  final isar = await ref.watch(downloadedBooksStoreProvider.future);

  var newResource = DownloadedBook()
    ..bookId = attrs['bookId']
    ..title = attrs['title']
    ..excerpt = attrs['excerpt']
    ..publisher = attrs['publisher']
    ..price = attrs['price']
    ..image = attrs['image']
    ..document = attrs['document']
    ..authors = attrs['authors']
    ..publishedAt = attrs['publishedAt'];

  return await isar.writeTxn(() async {
    await isar.downloadedBooks.put(newResource);
  });
});

final deleteDownloadedBookProvider = FutureProvider.autoDispose
    .family<dynamic, String>((ref, String bookId) async {
  final isar = await ref.watch(downloadedBooksStoreProvider.future);

  final resource =
      await isar.downloadedBooks.where().bookIdEqualTo(bookId).findFirst();

  if (resource != null) {
    return await isar.writeTxn(() async {
      await isar.downloadedBooks.delete(resource.id);
    });
  }
});

class DownloadedBooksNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.watch(downloadedBooksStoreProvider.future);
    var allResources =
        await isar.downloadedBooks.where().sortByPublishedAtDesc().findAll();
    return allResources;
  }

  Future<dynamic> deleteItem(bookId) async {
    final isar = await ref.watch(downloadedBooksStoreProvider.future);

    final resource =
        await isar.downloadedBooks.where().bookIdEqualTo(bookId).findFirst();

    if (resource != null) {
      await isar.writeTxn(() async {
        await isar.downloadedBooks.delete(resource.id);
      });

      state = AsyncValue.data(
        await isar.downloadedBooks.where().sortByPublishedAtDesc().findAll(),
      );
    }
  }
}

final downloadedBooksProvider =
    AsyncNotifierProvider.autoDispose<DownloadedBooksNotifier, List>(() {
  return DownloadedBooksNotifier();
});

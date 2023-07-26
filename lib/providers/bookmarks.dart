import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_app/models/bookmark.dart';

final bookmarksStoreProvider = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return Isar.getInstance('bookmarks') ??
      await Isar.open([BookmarkSchema], directory: dir.path, name: 'bookmarks');
});

class BookmarkNotifier
    extends AutoDisposeFamilyAsyncNotifier<Bookmark?, String> {
  @override
  Future<Bookmark?> build(String arg) async {
    final isar = await ref.read(bookmarksStoreProvider.future);
    final bookmark = await isar.bookmarks.where().linkEqualTo(arg).findFirst();
    return bookmark;
  }

  Future<dynamic> createItem(Map attrs) async {
    final isar = await ref.read(bookmarksStoreProvider.future);

    var newBookmark = Bookmark()
      ..type = attrs['type']
      ..title = attrs['title']
      ..link = attrs['link']
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.bookmarks.put(newBookmark);
    });

    final createdBookmark =
        await isar.bookmarks.where().linkEqualTo(newBookmark.link).findFirst();
    state = AsyncValue.data(createdBookmark);
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.read(bookmarksStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.bookmarks.delete(id);
    });

    final deletedBookmark = await isar.bookmarks.get(id);
    state = AsyncValue.data(deletedBookmark);
  }
}

final bookmarkProvider = AsyncNotifierProvider.autoDispose
    .family<BookmarkNotifier, Bookmark?, String>(
  BookmarkNotifier.new,
);

class BookmarksNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.read(bookmarksStoreProvider.future);
    var allBookmarks =
        await isar.bookmarks.where().sortByCreatedAtDesc().findAll();
    return allBookmarks;
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.read(bookmarksStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.bookmarks.delete(id);
    });

    state = AsyncValue.data(
      await isar.bookmarks.where().sortByCreatedAtDesc().findAll(),
    );
  }
}

final bookmarksProvider =
    AsyncNotifierProvider.autoDispose<BookmarksNotifier, List>(() {
  return BookmarksNotifier();
});

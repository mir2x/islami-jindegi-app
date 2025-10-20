import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:native_app/models/ayah_bookmark.dart';

final ayahBookmarksStoreProvider = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  return Isar.getInstance('ayahBookmarks') ??
      await Isar.open(
        [AyahBookmarkSchema],
        directory: dir.path,
        name: 'ayahBookmarks',
      );
});

class AyahBookmarkNotifier
    extends AutoDisposeFamilyAsyncNotifier<AyahBookmark?, String> {
  @override
  Future<AyahBookmark?> build(String arg) async {
    final isar = await ref.watch(ayahBookmarksStoreProvider.future);
    final bookmark =
        await isar.ayahBookmarks.where().ayahIdEqualTo(arg).findFirst();
    return bookmark;
  }

  Future<dynamic> createItem(Map attrs) async {
    final isar = await ref.watch(ayahBookmarksStoreProvider.future);

    var newBookmark = AyahBookmark()
      ..ayahId = attrs['ayahId']
      ..title = attrs['title']
      ..translation = attrs['translation']
      ..position = attrs['position']
      ..surahId = attrs['surahId']
      ..surahTitle = attrs['surahTitle']
      ..surahTitleBn = attrs['surahTitleBn']
      ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.ayahBookmarks.put(newBookmark);
    });

    final createdBookmark = await isar.ayahBookmarks
        .where()
        .ayahIdEqualTo(newBookmark.ayahId)
        .findFirst();
    state = AsyncValue.data(createdBookmark);
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.watch(ayahBookmarksStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.ayahBookmarks.delete(id);
    });

    final deletedBookmark = await isar.ayahBookmarks.get(id);
    state = AsyncValue.data(deletedBookmark);
  }
}

final ayahBookmarkProvider = AsyncNotifierProvider.autoDispose
    .family<AyahBookmarkNotifier, AyahBookmark?, String>(
  AyahBookmarkNotifier.new,
);

class AyahBookmarksNotifier extends AutoDisposeAsyncNotifier<List> {
  @override
  Future<List> build() async {
    final isar = await ref.watch(ayahBookmarksStoreProvider.future);
    var allBookmarks =
        await isar.ayahBookmarks.where().sortByCreatedAtDesc().findAll();
    return allBookmarks;
  }

  Future<dynamic> deleteItem(id) async {
    final isar = await ref.watch(ayahBookmarksStoreProvider.future);

    await isar.writeTxn(() async {
      await isar.ayahBookmarks.delete(id);
    });

    state = AsyncValue.data(
      await isar.ayahBookmarks.where().sortByCreatedAtDesc().findAll(),
    );
  }
}

final ayahBookmarksProvider =
    AsyncNotifierProvider.autoDispose<AyahBookmarksNotifier, List>(() {
  return AyahBookmarksNotifier();
});

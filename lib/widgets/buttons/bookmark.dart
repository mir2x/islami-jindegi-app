import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/bookmarks.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({
    super.key,
    required this.type,
    required this.title,
    required this.link,
  });

  final String type;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var bookmarkProviderWithLink = bookmarkProvider(link);
    var bookmarkQuery = ref.watch(bookmarkProviderWithLink);

    return bookmarkQuery.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (bookmark) {
        if (bookmark != null) {
          return IconButton(
            icon: const Icon(Icons.bookmark_remove),
            onPressed: () async {
              ref
                  .read(bookmarkProviderWithLink.notifier)
                  .deleteItem(bookmark.id);
            },
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: () async {
              ref.read(bookmarkProviderWithLink.notifier).createItem({
                'type': type,
                'title': title,
                'link': link,
              });
            },
          );
        }
      },
    );
  }
}

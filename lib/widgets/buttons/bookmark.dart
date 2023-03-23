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
            onPressed: () {
              ref
                  .read(bookmarkProviderWithLink.notifier)
                  .deleteItem(bookmark.id);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark deleted')),
              );
            },
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: () {
              ref.read(bookmarkProviderWithLink.notifier).createItem({
                'type': type,
                'title': title,
                'link': link,
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark added')),
              );
            },
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/providers/bookmarks.dart';
import 'package:native_app/theme/app_theme_color.dart';

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
    var locales = AppLocalizations.of(context)!;
    var bookmarkProviderWithLink = bookmarkProvider(link);
    var bookmarkQuery = ref.watch(bookmarkProviderWithLink);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return bookmarkQuery.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (bookmark) {
        if (bookmark != null) {
          return IconButton(
            icon: const Icon(Icons.bookmark_remove),
            color: colors.active,
            onPressed: () {
              ref
                  .read(bookmarkProviderWithLink.notifier)
                  .deleteItem(bookmark.id);

              var scaffoldMessenger = ScaffoldMessenger.of(context);
              scaffoldMessenger.removeCurrentSnackBar();

              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(locales.bookmarkDeleted)),
              );
            },
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.bookmark_add),
            color: colors.active,
            onPressed: () {
              ref.read(bookmarkProviderWithLink.notifier).createItem({
                'type': type,
                'title': title,
                'link': link,
              });
              var scaffoldMessenger = ScaffoldMessenger.of(context);
              scaffoldMessenger.removeCurrentSnackBar();

              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(locales.bookmarkAdded)),
              );
            },
          );
        }
      },
    );
  }
}

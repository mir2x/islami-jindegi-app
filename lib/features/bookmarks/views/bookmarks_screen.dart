import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/bookmarks.dart';
import 'package:native_app/theme/app_theme_color.dart';

class Bookmarks extends ConsumerWidget {
  const Bookmarks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var bookmarks = ref.watch(bookmarksProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return AppScaffold(
      onBackPressed: () async { if (context.canPop()) context.pop(); else context.go('/'); },
      title: Text(locales.bookmarks),
      body: bookmarks.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text(error.toString()),
        data: (resources) {
          return ListView.separated(
            itemCount: resources.length,
            itemBuilder: (BuildContext context, int index) {
              var item = resources[index];

              return Material(
                child: ListTile(
                  title: Text(item.title!),
                  subtitle: Text(item.type!, style: textTheme.labelSmall),
                  onTap: () {
                    final link = item.link!;
                    context.push(link.startsWith('/') ? link : '/$link');
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: colors.primary,
                    onPressed: () async {
                      ref.read(bookmarksProvider.notifier).deleteItem(item.id);
                    },
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 2);
            },
          );
        },
      ),
    );
  }
}

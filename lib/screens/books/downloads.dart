import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/downloaded_books.dart';

class BookDownloads extends ConsumerWidget {
  const BookDownloads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var books = ref.watch(downloadedBooksProvider);

    return AppScaffold(
      title: Text('${locales.downloaded} ${locales.books}'),
      body: books.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text(error.toString()),
        data: (resources) {
          if (resources.isNotEmpty) {
            return ListView.separated(
              itemCount: resources.length,
              itemBuilder: (BuildContext context, int index) {
                var item = resources[index];

                return Material(
                  child: ListTile(
                    title: Text(item.title!),
                    subtitle: Text(item.authors!, style: textTheme.labelSmall),
                    onTap: () => QR.to('books/downloads/${item.id}'),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 2);
              },
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Text(
                  locales.noItemsTitle,
                  style: textTheme.labelMedium,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

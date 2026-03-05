import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import '../providers/book_download_providers.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var books = ref.watch(downloadedBooksProvider);

    return AppScaffold(
      title: Text('${locales.downloaded} ${locales.books}'),
      body: books.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (resources) {
          if (resources.isNotEmpty) {
            return ListView.separated(
              itemCount: resources.length,
              itemBuilder: (BuildContext context, int index) {
                var item = resources[index];

                return Material(
                  child: ListTile(
                    title: Text(item.title ?? ''),
                    subtitle:
                        Text(item.authors ?? '', style: textTheme.labelSmall),
                    onTap: () => context.push('/books/downloads/${item.bookId}'),
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

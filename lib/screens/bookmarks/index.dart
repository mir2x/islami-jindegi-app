import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:native_app/widgets/layouts/scaffold.dart';
import 'package:native_app/providers/bookmarks.dart';

class Bookmarks extends ConsumerWidget {
  const Bookmarks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTheme = Theme.of(context).textTheme;
    var bookmarks = ref.watch(bookmarksProvider);

    return MyScaffold(
      title: const Text('Bookmarks'),
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
                  onTap: () => QR.to(item.link!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
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

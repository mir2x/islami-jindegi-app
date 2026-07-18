import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/downloaded_masail.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class MasailDownloadsScreen extends ConsumerWidget {
  const MasailDownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var masail = ref.watch(downloadedMasailProvider);

    return AppScaffold(
      title: Text('${locales.downloaded} ${locales.masail}'),
      body: masail.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text(error.toString()),
        data: (resources) {
          if (resources.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: resources.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = resources[index];

                  return InkWell(
                    onTap: () => context.push('/masail/downloads/${item.id}'),
                    child: ListItem(
                      item: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.titleMedium,
                          ),
                          if (item.author != null) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                item.author,
                                style: textTheme.labelSmall,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
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

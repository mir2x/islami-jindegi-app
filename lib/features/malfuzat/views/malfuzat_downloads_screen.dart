import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/downloaded_malfuzat.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class MalfuzatDownloadsScreen extends ConsumerWidget {
  const MalfuzatDownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var malfuzat = ref.watch(downloadedMalfuzatProvider);

    return AppScaffold(
      title: Text('${locales.downloaded} ${locales.malfuzat}'),
      body: malfuzat.when(
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
                    onTap: () => context.push('/malfuzat/downloads/${item.id}'),
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

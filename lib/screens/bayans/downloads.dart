import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/downloaded_bayans.dart';
import 'package:native_app/widgets/presentation/list_item.dart';
import 'package:native_app/helpers/format_date.dart';

class BayanDownloads extends ConsumerWidget {
  const BayanDownloads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var bayans = ref.watch(downloadedBayansProvider);

    return AppScaffold(
      title: Text('${locales.downloaded} ${locales.bayans}'),
      body: bayans.when(
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
                    onTap: () => QR.to('bayans/downloads/${item.id}'),
                    child: ListItem(
                      item: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.titleMedium,
                          ),
                          if (item.speaker != null) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 3),
                              child: Text(
                                item.speaker,
                                style: textTheme.labelMedium,
                              ),
                            ),
                          ],
                          if (item.location != null) ...[
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: Text(
                                item.location,
                                style: textTheme.labelSmall,
                              ),
                            ),
                          ],
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              formatDate(item.publishedAt, currentLang),
                              style: textTheme.labelSmall,
                            ),
                          ),
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

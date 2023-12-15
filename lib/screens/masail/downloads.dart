import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/downloaded_masail.dart';
import 'package:native_app/widgets/presentation/list_item.dart';

class MasailDownloads extends ConsumerWidget {
  const MasailDownloads({
    super.key,
  });

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
          return Container(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (BuildContext context, int index) {
                var item = resources[index];

                return InkWell(
                  onTap: () => QR.to('masail/downloads/${item.id}'),
                  child: ListItem(
                    item: Text(
                      item.title,
                      style: textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/downloaded_bayans.dart';

class BayanDownloads extends ConsumerWidget {
  const BayanDownloads({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var bayans = ref.watch(downloadedBayansProvider);

    return AppScaffold(
      title: Text('${locales.downloaded} ${locales.bayans}'),
      body: bayans.when(
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
                  subtitle: Text(item.speaker!, style: textTheme.labelSmall),
                  onTap: () => QR.to(item.link!),
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

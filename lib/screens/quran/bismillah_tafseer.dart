import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/utils/html_text.dart';

class BismillahTafseer extends ConsumerWidget {
  const BismillahTafseer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = AllModelsQuery(
      repository: ref.pages,
      params: const {'slug': 'bismillah-tafseer', 'quantity': 1},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Text(
              locales.tafseer,
              style: textTheme.headlineMedium,
            ),
          ),
          modelQuery.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, _) => Text(error.toString()),
            data: (resources) {
              if (resources.isNotEmpty) {
                var item = resources[0];

                return Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: HtmlText(
                    text: item.body,
                  ),
                );
              } else {
                return Text(locales.noContent);
              }
            },
          ),
        ],
      ),
    );
  }
}

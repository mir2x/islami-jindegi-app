import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/first_model.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
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

    var modelQuery = ref.watch(firstModelProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: SizedBox.shrink(),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (item) {
        return AppScaffold(
          title: Text(locales.tafseer),
          body: ItemContent(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِیْمِ',
                  textDirection: TextDirection.rtl,
                  softWrap: false,
                  style: textTheme.headlineLarge,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: HtmlText(
                  text: item.body,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/screens/error_pages/model_exception_handler.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/theme/colors.dart';

class AskQuestion extends ConsumerWidget {
  const AskQuestion({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var query = AllModelsQuery(
      repository: ref.pages,
      params: const {'slug': 'ask-masail', 'quantity': 1},
    );

    var modelQuery = ref.watch(allModelsProvider(query));

    return modelQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (resources) {
        var item = resources.first;

        return AppScaffold(
          showPattern: false,
          title: Text(locales.askQuestion),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: HtmlText(text: item.body),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: ThemeColors.color4,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                child: Text(
                  locales.askAQuestion,
                  style: textTheme.labelLarge?.copyWith(
                    color: ThemeColors.color7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  String email = Uri.encodeComponent('islamijindegi@gmail.com');
                  String body = Uri.encodeComponent(
                    '${locales.yourNameOptional}:\n${locales.yourContactOptional}:\n\n${locales.transactionIdRequired}:\n\n\n${locales.questionRequired}:',
                  );

                  Uri mail = Uri.parse('mailto:$email?body=$body');
                  await launchUrl(mail);
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  locales.emailAppHint,
                  style: textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

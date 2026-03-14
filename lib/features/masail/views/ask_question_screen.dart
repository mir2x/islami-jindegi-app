import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:native_app/widgets/layouts/placeholder_scaffold.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/utils/html_text.dart';
import 'package:native_app/widgets/error_pages/model_exception_handler.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../providers/masail_providers.dart';

class AskQuestionScreen extends ConsumerWidget {
  const AskQuestionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var pageQuery = ref.watch(askQuestionPageProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return pageQuery.when(
      loading: () {
        return const PlaceholderScaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) => ModelExeptionHandler(error: error),
      data: (item) {
        if (item == null) {
          return AppScaffold(
            showPattern: false,
            title: Text(locales.askQuestion),
            body: Center(
              child: Text(locales.noItemsTitle),
            ),
          );
        }

        return AppScaffold(
          showPattern: false,
          title: Text(locales.askQuestion),
          body: ItemContent(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: HtmlText(text: item.body ?? ''),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: colors.highlight,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                child: Text(
                  locales.askAQuestion,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  String email = Uri.encodeComponent('islamijindegi@gmail.com');
                  String body = Uri.encodeComponent(
                    '${locales.yourNameOptional}:\n${locales.yourContactOptional}:\n\n\n${locales.questionRequired}:',
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

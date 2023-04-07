import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/theme/colors.dart';

class AskQuestion extends StatelessWidget {
  const AskQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: Text(locales.askQuestion),
      body: ItemContent(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(locales.instructions, style: textTheme.headlineMedium),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(locales.sendMoney),
          ),
          Text('01611162167', style: textTheme.titleLarge),
          Text('01618811737', style: textTheme.titleLarge),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 40),
            child: Text(locales.provideTransactionId),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              locales.emailAppHint,
              style: textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

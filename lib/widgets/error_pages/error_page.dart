import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: Text(title),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: textTheme.headlineLarge,
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 60),
              child: Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (context.canPop()) context.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(right: 15),
                    child: Text(
                      locales.goBack,
                      style: textTheme.titleLarge,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => context.go('/'),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      locales.home,
                      style: textTheme.titleLarge,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

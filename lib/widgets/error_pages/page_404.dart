import 'package:flutter/material.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'error_page.dart';

class Page404 extends StatelessWidget {
  const Page404({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return ErrorPage(
      title: locales.pageNotFoundTitle,
      subtitle: locales.pageNotFoundMsg,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectToInternet extends StatelessWidget {
  const ConnectToInternet({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/icons/offline.svg',
          width: 70,
          height: 70,
        ),
        const SizedBox(height: 15),
        Text(locales.connectToInternetMsg, textAlign: TextAlign.center),
      ],
    );
  }
}

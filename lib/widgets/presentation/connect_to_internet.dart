import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectToInternet extends StatelessWidget {
  const ConnectToInternet({super.key});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.signal_wifi_connected_no_internet_4, size: 60),
        const SizedBox(height: 10),
        Text(locales.connectToInternetMsg, textAlign: TextAlign.center),
      ],
    );
  }
}

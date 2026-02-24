import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';

class Mosques extends ConsumerWidget {
  const Mosques({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var geoData = ref.watch(geolocationProvider);

    return AppScaffold(
      title: Text(locales.mosques),
      body: geoData.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Text(error.toString()),
        data: (Map geolocation) {
          double latitude = geolocation['coordinates']['latitude'];
          double longitude = geolocation['coordinates']['longitude'];

          return WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageStarted: (String url) {},
                  onPageFinished: (String url) {},
                  onHttpError: (HttpResponseError error) {},
                  onWebResourceError: (WebResourceError error) {},
                ),
              )
              ..loadRequest(
                Uri.parse(
                  'https://www.google.com/maps/search/mosque/@$latitude,$longitude,15z',
                ),
              ),
          );
        },
      ),
    );
  }
}

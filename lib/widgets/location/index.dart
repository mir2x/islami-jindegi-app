import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/helpers/update_app_widget.dart';

class CurrentLocation extends ConsumerStatefulWidget {
  const CurrentLocation({
    super.key,
    this.alignment = MainAxisAlignment.start,
  });

  final MainAxisAlignment alignment;

  @override
  CurrentLocationState createState() => CurrentLocationState();
}

class CurrentLocationState extends ConsumerState<CurrentLocation> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(minutes: 30),
      (Timer t) => setState(() {}),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return geoData.when(
      loading: () => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Text(error.toString()),
      data: (Map geolocation) {
        String location = [
          geolocation['location']['city'],
          geolocation['location']['country']
        ].where((v) => v is String && v.isNotEmpty).join(', ');

        updateAppWidget({'location': location});

        return Row(
          mainAxisAlignment: widget.alignment,
          children: [
            Text(location, style: textTheme.labelSmall),
            if (!geolocation['isGeolocated']) ...[
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () => ref
                      .read(geolocationProvider.notifier)
                      .updateCoordinates(),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/location.svg',
                        fit: BoxFit.scaleDown,
                        width: 30,
                        height: 23,
                      ),
                      const SizedBox(width: 4),
                      Text(locales.setLocation, style: textTheme.labelSmall),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

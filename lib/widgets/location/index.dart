import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/preferences.dart';
import 'package:native_app/helpers/get_location_name.dart';

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
      loading: () {
        var prefs = ref.watch(preferencesProvider);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefs.when(
              loading: () => const SizedBox(
                width: 10,
                height: 10,
              ),
              error: (error, _) => Text(error.toString()),
              data: (preferences) {
                String? location = preferences.getString('location');

                if (location != null) {
                  return Text(location, style: textTheme.labelSmall);
                } else {
                  return Text(
                    '${locales.dhaka}, ${locales.bangladesh}',
                    style: textTheme.labelSmall,
                  );
                }
              },
            ),
            const SizedBox(width: 10),
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          ],
        );
      },
      error: (error, _) => Text(error.toString()),
      data: (Map geolocation) {
        String location = getLocationName(geolocation['location']);

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

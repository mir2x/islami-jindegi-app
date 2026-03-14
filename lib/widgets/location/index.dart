import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/theme/app_theme_color.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';

class CurrentLocation extends ConsumerStatefulWidget {
  const CurrentLocation({
    super.key,
    this.alignment = MainAxisAlignment.start,
    this.oppositeColor = false,
  });

  final MainAxisAlignment alignment;
  final bool oppositeColor;

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
      (Timer t) async {
        Map geolocation = await ref.read(geolocationProvider.future);

        if (geolocation['isGeolocated']) {
          await ref.read(geolocationProvider.notifier).updateCoordinates();
        }
      },
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

    final appColors = Theme.of(context).extension<AppThemeColors>()!;

    return WithPreferences(
      builder: (context, preferences) {
        return geoData.when(
          loading: () {
            String? location = preferences.getString('location');
            String locationText =
                location ?? '${locales.dhaka}, ${locales.bangladesh}';

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  locationText,
                  style: textTheme.labelSmall?.copyWith(
                    color: widget.oppositeColor ? appColors.appBarText : null,
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  width: 23,
                  height: 23,
                  child: Center(
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(strokeWidth: 1),
                    ),
                  ),
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
                Text(
                  location,
                  style: textTheme.labelSmall?.copyWith(
                    color: widget.oppositeColor ? appColors.appBarText : null,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: InkWell(
                    onTap: () => context.push('/location'),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icons/location.svg',
                          fit: BoxFit.scaleDown,
                          width: 30,
                          height: 23,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          locales.location,
                          style: textTheme.labelSmall?.copyWith(
                            color: widget.oppositeColor
                                ? appColors.appBarText
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

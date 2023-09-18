import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'package:native_app/widgets/presentation/section_title.dart';

class Location extends ConsumerWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return AppScaffold(
      title: Text(locales.location),
      body: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 25,
        ),
        child: geoData.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text(error.toString()),
          data: (Map geolocation) {
            String location = getLocationName(geolocation['location']);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location, style: textTheme.labelLarge),
                const SizedBox(height: 40),
                Text(locales.waysOfSettingLocation,
                    style: textTheme.labelMedium,),
                const SizedBox(height: 40),
                Text(locales.withGeolocation, style: textTheme.labelMedium),
                if (!geolocation['isGeolocated']) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () => ref
                          .read(geolocationProvider.notifier)
                          .updateCoordinates(),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/location.svg',
                            width: 70,
                            height: 53,
                          ),
                          const SizedBox(width: 10),
                          Text(locales.giveGeolocationPermission,
                              style: textTheme.labelMedium,),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 50),
                Text(locales.manualLocation, style: textTheme.labelMedium),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionTitle(title: locales.country),
                      Dropdown(
                        items: const [
                          {'label': 'Bangladesh'},
                        ],
                        selectedValue: null,
                        updateItem: (value) {},
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionTitle(title: locales.city),
                      Dropdown(
                        items: const [
                          {'label': 'Dhaka'},
                        ],
                        selectedValue: null,
                        updateItem: (value) {},
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

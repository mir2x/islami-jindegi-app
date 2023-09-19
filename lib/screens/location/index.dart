import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
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
            Map location = geolocation['location'];
            String locationName = getLocationName(location);

            var countryQuery = ref.watch(
              allModelsProvider(
                AllModelsQuery(
                  repository: ref.countries,
                ),
              ),
            );

            var cityQuery = ref.watch(
              allModelsProvider(
                AllModelsQuery(
                  repository: ref.cities,
                  params: {'country_code': location['countryCode']},
                ),
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locationName, style: textTheme.labelLarge),
                const SizedBox(height: 40),
                Text(
                  locales.waysOfSettingLocation,
                  style: textTheme.labelMedium,
                ),
                const SizedBox(height: 40),
                Text(locales.withGeolocation, style: textTheme.labelMedium),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: (!geolocation['isGeolocated'])
                      ? InkWell(
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
                              if (!geolocation['isGeolocated']) ...[
                                Text(
                                  locales.giveGeolocationPermission,
                                  style: textTheme.labelMedium,
                                ),
                              ] else ...[
                                Text(
                                  locales.geolocationEnabled,
                                  style: textTheme.labelMedium,
                                ),
                              ],
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/icons/location.svg',
                              width: 70,
                              height: 53,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              locales.geolocationEnabled,
                              style: textTheme.labelMedium,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 50),
                Text(locales.manualLocation, style: textTheme.labelMedium),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionTitle(title: locales.country),
                      countryQuery.when(
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        error: (error, _) => Text(error.toString()),
                        data: (resources) {
                          var countries = resources.map((resource) {
                            return {
                              'label': resource.name,
                              'value': resource.code,
                            };
                          }).toList();

                          return Dropdown(
                            items: countries,
                            selectedValue: location['countryCode'],
                            updateItem: (value) async {
                              var selectedItem = countries.firstWhere(
                                (o) => o['value'] == value,
                              );

                              await setCountry({
                                'country': selectedItem['label'],
                                'countryCode': selectedItem['value'],
                              });

                              ref
                                  .read(geolocationProvider.notifier)
                                  .updateGeolocation();
                            },
                          );
                        },
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
                      cityQuery.when(
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        error: (error, _) => Text(error.toString()),
                        data: (resources) {
                          var cities = resources.map((resource) {
                            return {
                              'label': resource.name,
                              'value': resource.name,
                              'coordinates': {
                                'latitude': resource.latitude,
                                'longitude': resource.longitude,
                              },
                            };
                          }).toList();

                          return Dropdown(
                            items: cities,
                            selectedValue: cities.firstWhereOrNull(
                              (o) => o['value'] == location['city'],
                            )?['value'],
                            updateItem: (value) async {
                              var selectedItem = cities.firstWhere(
                                (o) => o['value'] == value,
                              );

                              await setCity({
                                'city': selectedItem['value'],
                                'coordinates': selectedItem['coordinates'],
                              });

                              ref
                                  .read(geolocationProvider.notifier)
                                  .updateGeolocation();
                            },
                          );
                        },
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

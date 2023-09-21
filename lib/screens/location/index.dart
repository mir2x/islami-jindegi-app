import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:native_app/main.data.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/providers/all_models.dart';
import 'package:native_app/objects/all_models_query.dart';
import 'package:native_app/widgets/buttons/dropdown.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/widgets/presentation/section_title.dart';
import 'package:native_app/helpers/get_location_name.dart';

class Location extends ConsumerWidget {
  const Location({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return AppScaffold(
      title: Text(locales.location),
      body: ItemContent(
        children: [
          geoData.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text(error.toString()),
            data: (Map geolocation) {
              String locationName = getLocationName(geolocation['location']);

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
                    margin: const EdgeInsets.only(top: 15),
                    child: (!geolocation['isGeolocated'])
                        ? InkWell(
                            onTap: () => ref
                                .read(geolocationProvider.notifier)
                                .updateCoordinates(),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/location.svg',
                                  width: 75,
                                  height: 57,
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
                                width: 75,
                                height: 57,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 8,
                                      left: 8,
                                    ),
                                    child: Text(
                                      locales.geolocationEnabled,
                                      style: textTheme.labelMedium,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: openAppSettings,
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: const EdgeInsets.all(8),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      locales.disable,
                                      style: textTheme.titleMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locales.benefits, style: textTheme.titleMedium),
                      const SizedBox(height: 5),
                      Text(
                        locales.geolocationBenefits,
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const ManualLocation(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ManualLocation extends ConsumerStatefulWidget {
  const ManualLocation({super.key});

  @override
  ManualLocationState createState() => ManualLocationState();
}

class ManualLocationState extends ConsumerState<ManualLocation> {
  dynamic selectedCountry;

  void updateCountry(value) {
    setState(() {
      selectedCountry = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return geoData.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
      data: (Map geolocation) {
        Map location = geolocation['location'];
        Map country = {
          'name': selectedCountry?.name ?? location['country'],
          'code': selectedCountry?.code ?? location['countryCode'],
        };

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
              params: {'country_code': country['code']},
            ),
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          'value': resource.name,
                        };
                      }).toList();

                      return Dropdown(
                        items: countries,
                        selectedValue: countries.firstWhereOrNull(
                          (o) => o['value'] == country['name'],
                        )?['value'],
                        searchEnabled: true,
                        searchHint: '${locales.searchCountry} ...',
                        updateItem: (value) async {
                          var selectedItem = resources.firstWhere(
                            (o) => o.name == value,
                          );

                          updateCountry(selectedItem);
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
                        };
                      }).toList();

                      return Dropdown(
                        items: cities,
                        selectedValue: cities.firstWhereOrNull(
                          (o) => o['value'] == location['city'],
                        )?['value'],
                        searchEnabled: true,
                        searchHint: '${locales.searchCity} ...',
                        updateItem: (value) async {
                          var selectedItem = resources.firstWhere(
                            (o) => o.name == value,
                          );

                          await setLocation({
                            'country': country['name'],
                            'countryCode': selectedItem.countryCode,
                            'city': selectedItem.name,
                            'coordinates': {
                              'latitude': selectedItem.latitude,
                              'longitude': selectedItem.longitude,
                            },
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
    );
  }
}

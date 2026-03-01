import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/widgets/inputs/search_field.dart';
import 'package:native_app/widgets/pagination/infinite_list.dart';
import 'package:native_app/helpers/contextual_translation.dart';

import '../providers/location_providers.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return AppScaffold(
      showPattern: false,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locales.manualLocation,
                        style: textTheme.labelMedium,
                      ),
                      WithPreferences(
                        builder: (context, preferences) {
                          var colorScheme = Theme.of(context).colorScheme;

                          return Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    double screenWidth =
                                        MediaQuery.of(context).size.width;
                                    double screenHeight =
                                        MediaQuery.of(context).size.height;

                                    return Dialog(
                                      child: Container(
                                        width: screenWidth,
                                        height: screenHeight * 0.6,
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 25,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: const ManualLocation(),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: colorScheme.outlineVariant,
                                ),
                                backgroundColor:
                                    colorScheme.surfaceContainerHighest,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                minimumSize: const Size.fromHeight(45),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getLocationName(geolocation['location']),
                                    style: textTheme.labelMedium,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 35,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
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
                                  width: 60,
                                  height: 46,
                                ),
                                const SizedBox(width: 10),
                                if (!geolocation['isGeolocated']) ...[
                                  Flexible(
                                    child: Text(
                                      locales.giveGeolocationPermission,
                                      style: textTheme.labelMedium,
                                    ),
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
                  const SizedBox(height: 20),
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
  String? countrySearchText;
  String? citySearchText;

  void updateCountry(value) {
    setState(() {
      selectedCountry = value;
    });
  }

  updateCountrySearchText(value) {
    setState(() {
      countrySearchText = value;
    });
  }

  updateCitySearchText(value) {
    setState(() {
      citySearchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    String currentLang = Localizations.localeOf(context).languageCode;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);

    return geoData.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, _) => Text(error.toString()),
      data: (Map geolocation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedCountry == null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                child: Text(
                  locales.selectCountry,
                  style: textTheme.labelLarge,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SearchField(
                  key: const Key('country-search'),
                  value: countrySearchText,
                  maxHeight: 35,
                  onUpdate: updateCountrySearchText,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: InfiniteList(
                    pageSize: 20,
                    padding: 10,
                    resourceFetcher: (Map<String, dynamic> params) async {
                      final api = ref.read(locationApiServiceProvider);
                      return await api.fetchCountries(
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 20,
                        search: countrySearchText,
                      );
                    },
                    itemBuilder: (_, item, __) {
                      String countryName = contextualTranslation(
                        locale: currentLang,
                        enText: item.name,
                        bnText: item.nameBn,
                      );

                      return InkWell(
                        onTap: () {
                          updateCountry(item);
                          updateCountrySearchText(null);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Text(
                            countryName,
                            style: textTheme.titleMedium,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      updateCountry(null);
                      updateCountrySearchText(null);
                      updateCitySearchText(null);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    contextualTranslation(
                      locale: currentLang,
                      enText: selectedCountry.name,
                      bnText: selectedCountry.nameBn,
                    ),
                    style: textTheme.labelLarge,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SearchField(
                  key: const Key('city-search'),
                  value: citySearchText,
                  maxHeight: 35,
                  onUpdate: updateCitySearchText,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: InfiniteList(
                    pageSize: 20,
                    padding: 10,
                    resourceFetcher: (Map<String, dynamic> params) async {
                      final api = ref.read(locationApiServiceProvider);
                      return await api.fetchCities(
                        countryCode: selectedCountry.code,
                        page: params['page'] ?? 1,
                        perPage: params['per_page'] ?? 20,
                        search: citySearchText,
                      );
                    },
                    itemBuilder: (_, item, __) {
                      String cityName = contextualTranslation(
                        locale: currentLang,
                        enText: item.name,
                        bnText: item.nameBn,
                      );

                      return InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();

                          updateCitySearchText(null);

                          String countryName = contextualTranslation(
                            locale: currentLang,
                            enText: selectedCountry.name,
                            bnText: selectedCountry.nameBn,
                          );

                          await setLocation({
                            'country': countryName,
                            'countryCode': item.countryCode,
                            'city': cityName,
                            'coordinates': {
                              'latitude': item.latitude,
                              'longitude': item.longitude,
                            },
                            'timezone': item.timezone,
                          });

                          ref
                              .read(geolocationProvider.notifier)
                              .updateGeolocation();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Text(
                            cityName,
                            style: textTheme.titleMedium,
                          ),
                        ),
                      );
                    },
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

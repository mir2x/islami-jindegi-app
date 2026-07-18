import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'package:native_app/widgets/layouts/app_scaffold.dart';
import 'package:native_app/providers/geolocation.dart';
import 'package:native_app/widgets/utils/with_preferences.dart';
import 'package:native_app/widgets/presentation/item_content.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/theme/app_theme_color.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locales = AppLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var geoData = ref.watch(geolocationProvider);
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return AppScaffold(
      onBackPressed: () async {
        if (context.canPop()) context.pop();
        else context.go('/');
      },
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
                  Text(locales.waysOfSettingLocation, style: textTheme.labelMedium),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locales.manualLocation, style: textTheme.labelMedium),
                      WithPreferences(
                        builder: (context, preferences) {
                          return Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    double screenWidth = MediaQuery.of(context).size.width;
                                    double screenHeight = MediaQuery.of(context).size.height;
                                    return Dialog(
                                      backgroundColor: colors.cardBg,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(color: colors.divider),
                                      ),
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
                                side: BorderSide(color: colors.divider),
                                backgroundColor: colors.cardBg,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size.fromHeight(45),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getLocationName(geolocation['location']),
                                    style: textTheme.labelMedium,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 35,
                                    color: colors.secondaryText,
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.divider),
                    ),
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
                                Flexible(
                                  child: Text(
                                    locales.giveGeolocationPermission,
                                    style: textTheme.labelMedium,
                                  ),
                                ),
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
                                    margin: const EdgeInsets.only(top: 8, left: 8),
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
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.divider),
                    ),
                    child: Column(
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

// ─── Manual location picker (offline, country_state_city package) ──────────────

class ManualLocation extends ConsumerStatefulWidget {
  const ManualLocation({super.key});

  @override
  ManualLocationState createState() => ManualLocationState();
}

class ManualLocationState extends ConsumerState<ManualLocation> {
  // Country step
  List<csc.Country>? _countries;
  csc.Country? _selectedCountry;
  final TextEditingController _countrySearch = TextEditingController();

  // City step — all cities cached once to avoid re-parsing the full JSON
  static List<csc.City>? _allCitiesCache;
  List<csc.City>? _cities;
  bool _citiesLoading = false;
  final TextEditingController _citySearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _countrySearch.addListener(() => setState(() {}));
    _citySearch.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _countrySearch.dispose();
    _citySearch.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final list = await csc.getAllCountries();
    if (mounted) setState(() => _countries = list);
  }

  Future<void> _selectCountry(csc.Country country) async {
    setState(() {
      _selectedCountry = country;
      _cities = null;
      _citiesLoading = true;
      _citySearch.clear();
    });

    // Load and cache all cities once; subsequent calls just filter in memory
    _allCitiesCache ??= await csc.getAllCities();
    final cities = _allCitiesCache!
        .where((c) => c.countryCode == country.isoCode)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    if (mounted) {
      setState(() {
        _cities = cities;
        _citiesLoading = false;
      });
    }
  }

  Future<void> _selectCity(csc.City city) async {
    final country = _selectedCountry!;
    final lat = double.tryParse(city.latitude ?? '') ?? 0.0;
    final lng = double.tryParse(city.longitude ?? '') ?? 0.0;
    final timezone = await timezoneFromCountryCode(country.isoCode);

    // Rename Israel → Palestine
    String countryName = country.name;
    if (countryName == 'Israel') countryName = 'Palestine';

    if (!context.mounted) return;
    Navigator.of(context).pop();

    await setLocation({
      'country': countryName,
      'countryCode': country.isoCode,
      'city': city.name,
      'coordinates': {'latitude': lat, 'longitude': lng},
      'timezone': timezone,
    });

    ref.read(geolocationProvider.notifier).updateGeolocation();
  }

  List<csc.Country> get _filteredCountries {
    if (_countries == null) return [];
    final q = _countrySearch.text.trim().toLowerCase();
    if (q.isEmpty) return _countries!;
    return _countries!.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  List<csc.City> get _filteredCities {
    if (_cities == null) return [];
    final q = _citySearch.text.trim().toLowerCase();
    if (q.isEmpty) return _cities!;
    return _cities!.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    if (_selectedCountry == null) {
      // ── Country picker ───────────────────────────────────────────
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
            child: Text(locales.selectCountry, style: textTheme.labelLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _SearchField(
              controller: _countrySearch,
              hint: locales.search,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _countries == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredCountries.length,
                    itemBuilder: (_, i) {
                      final c = _filteredCountries[i];
                      String displayName = c.name;
                      if (displayName == 'Israel') displayName = 'Palestine';
                      return InkWell(
                        onTap: () => _selectCountry(c),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 11,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: colors.divider),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(displayName, style: textTheme.titleMedium),
                              ),
                              Icon(Icons.chevron_right, size: 18, color: colors.secondaryText),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    // ── City picker ──────────────────────────────────────────────────
    String countryDisplay = _selectedCountry!.name;
    if (countryDisplay == 'Israel') countryDisplay = 'Palestine';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() {
                _selectedCountry = null;
                _cities = null;
                _countrySearch.clear();
              }),
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(countryDisplay, style: textTheme.labelLarge),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _SearchField(
            controller: _citySearch,
            hint: locales.search,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _citiesLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredCities.isEmpty
                  ? Center(
                      child: Text(
                        locales.noItemsTitle,
                        style: textTheme.labelMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredCities.length,
                      itemBuilder: (_, i) {
                        final city = _filteredCities[i];
                        return InkWell(
                          onTap: () => _selectCity(city),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 11,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: colors.divider),
                              ),
                            ),
                            child: Text(city.name, style: textTheme.titleMedium),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      controller: controller,
      style: textTheme.titleMedium,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: textTheme.titleMedium?.copyWith(color: colors.secondaryText),
        prefixIcon: Icon(Icons.search, size: 20, color: colors.secondaryText),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, size: 18, color: colors.secondaryText),
                onPressed: () => controller.clear(),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.active),
        ),
        filled: true,
        fillColor: colors.cardBg,
      ),
    );
  }
}

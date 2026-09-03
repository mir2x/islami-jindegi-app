import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:native_app/core/services/timezone_resolver.dart';
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/helpers/update_app_widget.dart';
import 'preferences.dart';

/// Set once the user picks a city by hand. Without it `GeolocationNotifier`
/// runs a GPS fix on every cold start and overwrites that choice, so a manually
/// selected location silently reverted to wherever the device actually is.
const String prefsLocationMode = 'locationMode';
const String locationModeManual = 'manual';
const String locationModeAuto = 'auto';

Future<bool> isManualLocation() async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getString(prefsLocationMode) == locationModeManual;
}

Future<void> setLocationMode(String mode) async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.setString(prefsLocationMode, mode);
}

Future<Map> getFailSafeGeolocation() async {
  Map coordinates = await getFailSafeCoordinates();
  Map location = await getFailSafeLocation();
  // Derived from the coordinates above, never from `location`: a country code
  // cannot name a zone for the 24 countries that span several UTC offsets.
  String timezone = await resolveTimezone(
    latitude: coordinates['latitude'],
    longitude: coordinates['longitude'],
  );

  return {
    'coordinates': coordinates,
    'location': location,
    'timezone': timezone,
    'isGeolocated': false,
  };
}

Future<Map> getFailSafeCoordinates() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString('latitude') != null &&
      preferences.getString('longitude') != null) {
    return {
      'latitude': double.parse(preferences.getString('latitude')!),
      'longitude': double.parse(preferences.getString('longitude')!),
    };
  } else {
    return {
      'latitude': 23.8103,
      'longitude': 90.4125,
    };
  }
}

Future<Map> getFailSafeLocation() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final String currentLocale = preferences.getString('locale') ?? 'bn';

  if ((preferences.getString('city')?.trim().isNotEmpty ?? false) &&
      (preferences.getString('country')?.trim().isNotEmpty ?? false) &&
      preferences.getString('countryCode') != null) {
    final String? storedLocale = preferences.getString('locationLocale');

    // Locale matches — use stored values as-is
    if (storedLocale == currentLocale) {
      return {
        'city': preferences.getString('city'),
        'country': preferences.getString('country'),
        'countryCode': preferences.getString('countryCode'),
      };
    }

    // Locale mismatch — return locale-appropriate defaults.
    // The next GPS geocode or manual location save will persist the correct names.
    return {
      'city': currentLocale == 'bn' ? 'ঢাকা' : 'Dhaka',
      'country': currentLocale == 'bn' ? 'বাংলাদেশ' : 'Bangladesh',
      'countryCode': preferences.getString('countryCode') ?? 'BD',
    };
  } else {
    return {
      'city': currentLocale == 'bn' ? 'ঢাকা' : 'Dhaka',
      'country': currentLocale == 'bn' ? 'বাংলাদেশ' : 'Bangladesh',
      'countryCode': 'BD',
    };
  }
}

/// Keeps the widget useful immediately after installation, before iOS grants
/// the first background refresh. A later GPS/manual-location update replaces
/// this fallback with the user's actual location.
Future<void> syncAppWidgetLocation() async {
  final location = await getFailSafeLocation();
  await updateAppWidget({'location': getLocationName(location)});
}

/// The zone for the stored coordinates.
///
/// Deliberately resolves rather than reading the stored string straight back:
/// an install upgrading from the country-code strategy is carrying a wrong
/// zone, and returning it unchanged is what made that bug permanent on a
/// device once it had been written.
Future<String> getFailSafeTimezone() async {
  final cached = await storedTimezone();
  if (cached.isNotEmpty) return cached;

  final coordinates = await getFailSafeCoordinates();
  return resolveTimezone(
    latitude: coordinates['latitude'],
    longitude: coordinates['longitude'],
  );
}

Map<String, String>? _countryNameToCodeCache;

/// Loads country.json once for the country-name -> ISO-code lookup.
///
/// The `timezones` array in this file is deliberately ignored. It lists every
/// zone a country contains, and the old code took the first one — which is
/// America/Adak for the US and Asia/Anadyr for Russia. Zones come from
/// `resolveTimezone`, which works from the coordinate.
Future<void> _ensureCountryCache() async {
  if (_countryNameToCodeCache != null) return;
  try {
    final raw = await rootBundle.loadString(
      'packages/country_state_city/lib/assets/country.json',
    );
    final list = jsonDecode(raw) as List;
    _countryNameToCodeCache = {};
    for (final item in list) {
      final code = item['isoCode'] as String?;
      final name = item['name'] as String?;
      if (code != null && name != null) {
        _countryNameToCodeCache![name.toLowerCase()] = code;
      }
    }
  } catch (_) {}
}

/// Resolves an ISO country code from a country name (e.g. "Bangladesh" → "BD").
/// Returns empty string if not found.
Future<String> _isoCodeFromCountryName(String? name) async {
  if (name == null || name.isEmpty) return '';
  await _ensureCountryCache();
  return _countryNameToCodeCache?[name.toLowerCase()] ?? '';
}

Future<Map> getLocation(Position position) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String locale = preferences.getString('locale') ?? 'bn';

  try {
    Geocoding().setLocaleIdentifier(locale);

    List<Placemark> placemarks = await Geocoding()
        .placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        )
        .timeout(const Duration(seconds: 30));

    Placemark placemark = placemarks.first;
    String? country = placemark.country;

    if (country == 'Israel') {
      country = 'Palestine';
    }

    if (country == 'ইসরাইল') {
      country = 'ফিলিস্তিন';
    }

    // Three-tier fallback for countryCode:
    //   1. placemark.isoCountryCode  (direct from geocoder — most reliable)
    //   2. name lookup via country_state_city JSON (geocoder sometimes omits code)
    //   3. previously stored countryCode                (last resort)
    String isoCode = placemark.isoCountryCode ?? '';
    if (isoCode.isEmpty) {
      isoCode = await _isoCodeFromCountryName(placemark.country);
    }
    if (isoCode.isEmpty) {
      isoCode = preferences.getString('countryCode') ?? '';
    }

    return {
      'city': placemark.locality,
      'country': country,
      'countryCode': isoCode.isNotEmpty ? isoCode : null,
    };
  } catch (error) {
    return await getFailSafeLocation();
  }
}

Future setLocation(Map location) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  // Always record the locale used when saving this location
  final String currentLocale = preferences.getString('locale') ?? 'bn';
  preferences.setString('locationLocale', currentLocale);

  // Every field below arrives from the reverse geocoder as `String?`, and
  // `getLocation` sets `countryCode` to null outright when no ISO code can be
  // resolved. They reach this function through an untyped `Map`, so a null is
  // typed `dynamic` and slips past the compiler into `setString`, whose value
  // parameter is non-nullable — throwing `type 'Null' is not a subtype of type
  // 'String'` at runtime.
  //
  // That throw escapes `GeolocationNotifier.build()` and leaves the whole
  // provider in an error state, so every screen rendering
  // `Text(error.toString())` paints the raw message where the Hijri date and
  // prayer times belong. It reproduces reliably wherever the geocoder returns a
  // partial placemark — common on iOS, and on Android devices whose geocoder
  // backend is unavailable.
  //
  // A missing field means the geocoder had nothing to say, not that the user
  // has no city, so the last known value is kept rather than overwritten.
  String? resolved(dynamic value) {
    final text = value is String ? value.trim() : null;
    return (text != null && text.isNotEmpty) ? text : null;
  }

  final String? country = resolved(location['country']);
  final String? countryCode = resolved(location['countryCode']);
  final String? city = resolved(location['city']);

  if (country != null && preferences.getString('country') != country) {
    preferences.setString('country', country);
  }

  if (countryCode != null &&
      preferences.getString('countryCode') != countryCode) {
    debugPrint('[Hijri][setLocation] countryCode changed: '
        '${preferences.getString('countryCode')} → $countryCode. '
        'Clearing Hijri cache.');
    preferences.setString('countryCode', countryCode);
    // Hijri date is country-specific — stale cache from another country must not
    // survive a location switch.
    preferences.remove('hijriDataToday');
    preferences.remove('hijriDataTomorrow');
  } else {
    debugPrint(
      '[Hijri][setLocation] countryCode unchanged: ${countryCode ?? preferences.getString('countryCode')}. Cache kept.',
    );
  }

  if (city != null && preferences.getString('city') != city) {
    preferences.setString('city', city);
  }

  if (preferences.getString('latitude') !=
      location['coordinates']['latitude'].toString()) {
    preferences.setString(
      'latitude',
      location['coordinates']['latitude'].toString(),
    );
  }

  if (preferences.getString('longitude') !=
      location['coordinates']['longitude'].toString()) {
    preferences.setString(
      'longitude',
      location['coordinates']['longitude'].toString(),
    );
  }

  // Resolved here rather than accepted from the caller: this is the one
  // function every location change goes through, so deriving the zone from the
  // coordinates it just wrote is what makes it impossible to store a location
  // and a zone that disagree.
  await resolveTimezone(
    latitude: (location['coordinates']['latitude'] as num).toDouble(),
    longitude: (location['coordinates']['longitude'] as num).toDouble(),
  );

  // Built from the values actually in effect, not from the incoming map: when
  // the geocoder omitted a field the stored one was deliberately kept above, so
  // reading `location` here would blank out a location name that is still valid.
  final String locationName = getLocationName({
    'city': city ?? preferences.getString('city'),
    'country': country ?? preferences.getString('country'),
  });

  if (preferences.getString('location') != locationName) {
    preferences.setString('location', locationName);
    await updateAppWidget({'location': locationName});
  }
}

Future updatePreferences(Map location, Position position) async {
  await setLocation({
    'country': location['country'],
    'countryCode': location['countryCode'],
    'city': location['city'],
    'coordinates': {
      'latitude': position.latitude,
      'longitude': position.longitude,
    },
  });
}

class GeolocationNotifier extends AsyncNotifier<Map> {
  @override
  Future<Map> build() async {
    bool serviceEnabled;
    LocationPermission permission;

    // A hand-picked city outranks the device's own position. This runs on every
    // cold start, so without the check the GPS fix below silently replaced the
    // user's choice — the reason a manually set location never survived a
    // restart. Tapping the geolocation card calls `updateCoordinates`, which
    // switches the mode back.
    if (await isManualLocation()) {
      return await getFailSafeGeolocation();
    }

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    } on MissingPluginException {
      return await getFailSafeGeolocation();
    }

    if (!serviceEnabled) {
      return await getFailSafeGeolocation();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return await getFailSafeGeolocation();
    }

    Position position;

    try {
      position = await Geolocator.getCurrentPosition()
          .timeout(const Duration(seconds: 30));
    } catch (error) {
      return await getFailSafeGeolocation();
    }

    var location = await getLocation(position);
    await updatePreferences(location, position);
    final timezone = await resolveTimezone(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return {
      'coordinates': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'location': location,
      'timezone': timezone,
      'isGeolocated': true,
    };
  }

  Future<dynamic> updateCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Reaching this is always a deliberate act — the geolocation card, or the
    // 30-minute refresh that only runs while already geolocated — so it is the
    // right place to leave manual mode.
    await setLocationMode(locationModeAuto);

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    } on MissingPluginException {
      openAppSettings();
      return;
    }

    if (!serviceEnabled) {
      openAppSettings();
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        openAppSettings();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      openAppSettings();
      return;
    }

    Position position;

    try {
      position = await Geolocator.getCurrentPosition()
          .timeout(const Duration(seconds: 30));
    } catch (error) {
      state = AsyncValue.data(await getFailSafeGeolocation());
      return;
    }

    var location = await getLocation(position);
    debugPrint('[Hijri][updateCoordinates] GPS location resolved: '
        'city=${location['city']}, country=${location['country']}, '
        'countryCode=${location['countryCode']}');
    await updatePreferences(location, position);
    final timezone = await resolveTimezone(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    debugPrint(
        '[Hijri][updateCoordinates] updatePreferences done. Setting state with countryCode=${location['countryCode']}');

    state = AsyncValue.data({
      'coordinates': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'location': location,
      'timezone': timezone,
      'isGeolocated': true,
    });
    debugPrint('[Hijri][updateCoordinates] geolocationProvider state updated.');
  }

  Future<dynamic> updateGeolocation() async {
    state = AsyncValue.data(await getFailSafeGeolocation());
  }
}

final geolocationProvider = AsyncNotifierProvider<GeolocationNotifier, Map>(() {
  return GeolocationNotifier();
});

final preferencesAndGeolocationProvider = FutureProvider<Map>((ref) async {
  final preferences = ref.watch(preferencesProvider.future);
  final geolocation = ref.watch(geolocationProvider.future);

  return {
    'preferences': await preferences,
    'geolocation': await geolocation,
  };
});

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
import 'package:native_app/helpers/get_location_name.dart';
import 'package:native_app/helpers/update_app_widget.dart';
import 'preferences.dart';

Future<Map> getFailSafeGeolocation() async {
  Map coordinates = await getFailSafeCoordinates();
  Map location = await getFailSafeLocation();
  String timezone = await getFailSafeTimezone();

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

  if (preferences.getString('city') != null &&
      preferences.getString('country') != null &&
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

Future<String> getFailSafeTimezone() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  final stored = preferences.getString('timezone');
  if (stored != null && stored.isNotEmpty) return stored;

  // No timezone stored yet — derive from countryCode and persist it
  final countryCode = preferences.getString('countryCode');
  if (countryCode != null && countryCode.isNotEmpty) {
    final tz = await timezoneFromCountryCode(countryCode);
    if (tz.isNotEmpty) {
      preferences.setString('timezone', tz);
      return tz;
    }
  }

  return '';
}

Map<String, String>? _countryTimezoneCache;
Map<String, String>? _countryNameToCodeCache;

/// Loads country.json once and populates both caches.
Future<void> _ensureCountryCache() async {
  if (_countryTimezoneCache != null && _countryNameToCodeCache != null) return;
  try {
    final raw = await rootBundle.loadString(
      'packages/country_state_city/lib/assets/country.json',
    );
    final list = jsonDecode(raw) as List;
    _countryTimezoneCache = {};
    _countryNameToCodeCache = {};
    for (final item in list) {
      final code = item['isoCode'] as String?;
      final name = item['name'] as String?;
      final zones = item['timezones'] as List?;
      if (code != null) {
        if (name != null) _countryNameToCodeCache![name.toLowerCase()] = code;
        if (zones != null && zones.isNotEmpty) {
          _countryTimezoneCache![code] = zones.first['zoneName'] as String? ?? '';
        }
      }
    }
  } catch (_) {}
}

Future<String> timezoneFromCountryCode(String isoCode) async {
  await _ensureCountryCache();
  return _countryTimezoneCache?[isoCode] ?? '';
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

  if (preferences.getString('country') != location['country']) {
    preferences.setString('country', location['country']);
  }

  if (preferences.getString('countryCode') != location['countryCode']) {
    debugPrint('[Hijri][setLocation] countryCode changed: '
        '${preferences.getString('countryCode')} → ${location['countryCode']}. '
        'Clearing Hijri cache.');
    preferences.setString('countryCode', location['countryCode']);
    // Hijri date is country-specific — stale cache from another country must not
    // survive a location switch.
    preferences.remove('hijriDataToday');
    preferences.remove('hijriDataTomorrow');
  } else {
    debugPrint('[Hijri][setLocation] countryCode unchanged: ${location['countryCode']}. Cache kept.');
  }

  if (preferences.getString('city') != location['city']) {
    preferences.setString('city', location['city']);
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

  if ((location['timezone'] != null) &&
      (preferences.getString('timezone') != location['timezone'])) {
    preferences.setString('timezone', location['timezone']);
  }

  String locationName = getLocationName(location);

  if (preferences.getString('location') != locationName) {
    preferences.setString('location', locationName);
    updateAppWidget({'location': locationName});
  }
}

Future updatePreferences(
  Map location,
  Position position,
  String timezone,
) async {
  await setLocation({
    'country': location['country'],
    'countryCode': location['countryCode'],
    'city': location['city'],
    'coordinates': {
      'latitude': position.latitude,
      'longitude': position.longitude,
    },
    'timezone': timezone,
  });
}

class GeolocationNotifier extends AsyncNotifier<Map> {
  @override
  Future<Map> build() async {
    bool serviceEnabled;
    LocationPermission permission;

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
    final isoCode = (location['countryCode'] as String?) ?? '';
    String timezone = isoCode.isNotEmpty
        ? await timezoneFromCountryCode(isoCode)
        : '';
    if (timezone.isEmpty) timezone = await getFailSafeTimezone();

    await updatePreferences(location, position, timezone);

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
    final isoCode = (location['countryCode'] as String?) ?? '';
    String timezone = isoCode.isNotEmpty
        ? await timezoneFromCountryCode(isoCode)
        : '';
    if (timezone.isEmpty) timezone = await getFailSafeTimezone();

    await updatePreferences(location, position, timezone);
    debugPrint('[Hijri][updateCoordinates] updatePreferences done. Setting state with countryCode=${location['countryCode']}');

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

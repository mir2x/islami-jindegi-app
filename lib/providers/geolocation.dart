import 'dart:async';
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

  if (preferences.getString('city') != null &&
      preferences.getString('country') != null &&
      preferences.getString('countryCode') != null) {
    return {
      'city': preferences.getString('city'),
      'country': preferences.getString('country'),
      'countryCode': preferences.getString('countryCode'),
    };
  } else {
    String locale = preferences.getString('locale') ?? 'bn';

    return {
      'city': locale == 'bn' ? 'ঢাকা' : 'Dhaka',
      'country': locale == 'bn' ? 'বাংলাদেশ' : 'Bangladesh',
      'countryCode': 'BD',
    };
  }
}

Future<String> getFailSafeTimezone() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString('timezone') != null) {
    return preferences.getString('timezone')!;
  } else {
    return '';
  }
}

Future<Map> getLocation(Position position) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String locale = preferences.getString('locale') ?? 'bn';

  try {
    await setLocaleIdentifier(locale);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    ).timeout(const Duration(seconds: 30));

    Placemark placemark = placemarks.first;
    String? country = placemark.country;

    if (country == 'Israel') {
      country = 'Palestine';
    }

    if (country == 'ইসরাইল') {
      country = 'ফিলিস্তিন';
    }

    return {
      'city': placemark.locality,
      'country': country,
      'countryCode': placemark.isoCountryCode,
    };
  } catch (error) {
    return await getFailSafeLocation();
  }
}

Future setLocation(Map location) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString('country') != location['country']) {
    preferences.setString('country', location['country']);
  }

  if (preferences.getString('countryCode') != location['countryCode']) {
    preferences.setString('countryCode', location['countryCode']);
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
    String timezone = await getFailSafeTimezone();

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
    String timezone = '';

    await updatePreferences(location, position, timezone);

    state = AsyncValue.data({
      'coordinates': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'location': location,
      'timezone': timezone,
      'isGeolocated': true,
    });
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

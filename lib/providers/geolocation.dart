import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'preferences.dart';

Future<Map> getFailSafeGeolocation() async {
  Map coordinates = await getFailSafeCoordinates();
  Map location = await getFailSafeLocation();

  return {
    'coordinates': coordinates,
    'location': location,
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

Future<Map> getLocation(Position position) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String locale = preferences.getString('locale') ?? 'bn';

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      localeIdentifier: locale,
    );

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

Future updatePreferences(Position position, Map location) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString('latitude') != position.latitude.toString()) {
    preferences.setString('latitude', position.latitude.toString());
  }

  if (preferences.getString('longitude') != position.longitude.toString()) {
    preferences.setString('longitude', position.longitude.toString());
  }

  if (preferences.getString('city') != location['city']) {
    preferences.setString('city', location['city']);
  }

  if (preferences.getString('country') != location['country']) {
    preferences.setString('country', location['country']);
  }

  if (preferences.getString('countryCode') != location['countryCode']) {
    preferences.setString('countryCode', location['countryCode']);
  }
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

    var position = await Geolocator.getCurrentPosition();
    var location = await getLocation(position);

    await updatePreferences(position, location);

    return {
      'coordinates': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'location': location,
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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();
    var location = await getLocation(position);

    await updatePreferences(position, location);

    state = AsyncValue.data({
      'coordinates': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      'location': location,
      'isGeolocated': true,
    });
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

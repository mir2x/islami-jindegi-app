import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'preferences.dart';

Future<Map> failSafeCoordinates() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString('latitude') != null &&
      preferences.getString('longitude') != null) {
    return {
      'coordinates': {
        'latitude': double.parse(preferences.getString('latitude')!),
        'longitude': double.parse(preferences.getString('longitude')!),
      },
      'isGeolocated': true,
    };
  } else {
    return {
      'coordinates': {
        'latitude': 23.8103,
        'longitude': 90.4125,
      },
      'isGeolocated': false,
    };
  }
}

final geolocationProvider = FutureProvider<Map>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return await failSafeCoordinates();
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return await failSafeCoordinates();
  }

  var position = await Geolocator.getCurrentPosition();

  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString('latitude') != position.latitude.toString()) {
    preferences.setString('latitude', position.latitude.toString());
  }

  if (preferences.getString('longitude') != position.longitude.toString()) {
    preferences.setString('longitude', position.longitude.toString());
  }

  return {
    'coordinates': {
      'latitude': position.latitude,
      'longitude': position.longitude,
    },
    'isGeolocated': true,
  };
});

final preferencesAndGeolocationProvider = FutureProvider<Map>((ref) async {
  final preferences = ref.watch(preferencesProvider.future);
  final geolocation = ref.watch(geolocationProvider.future);

  return {
    'preferences': await preferences,
    'geolocation': await geolocation,
  };
});

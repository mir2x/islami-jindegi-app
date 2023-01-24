import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'preferences.dart';

Future<Map> getFailSafeCoordinates() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (preferences.getString('latitude') != null &&
      preferences.getString('longitude') != null) {
    return {
      'coordinates': {
        'latitude': double.parse(preferences.getString('latitude')!),
        'longitude': double.parse(preferences.getString('longitude')!),
      },
      'isGeolocated': false,
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

class GeolocationNotifier extends AsyncNotifier<Map> {
  @override
  Future<Map> build() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return await getFailSafeCoordinates();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return await getFailSafeCoordinates();
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
  }

  Future<dynamic> updateCoordinates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();

    state = AsyncValue.data({
      'coordinates': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
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

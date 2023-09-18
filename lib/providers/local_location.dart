import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/local_server/location/local_location_api.dart';

final localLocationProvider = Provider((ref) => LocalLocationAPI());

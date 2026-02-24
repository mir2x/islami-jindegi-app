import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_api_service.dart';

final locationApiServiceProvider = Provider<LocationApiService>((ref) {
  return LocationApiService();
});

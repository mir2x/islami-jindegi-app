import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/country.dart';
import '../models/city.dart';

/// Dio-based service for fetching countries and cities.
class LocationApiService {
  late final Dio _dio;

  LocationApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  Future<List<CountryItem>> fetchCountries({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response = await _dio.get('/countries', queryParameters: params);
    final dataList = response.data['data'] as List? ?? [];
    return dataList.map((r) => CountryItem.fromJsonApi(r)).toList();
  }

  Future<List<CityItem>> fetchCities({
    required String countryCode,
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'country_code': countryCode,
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final response = await _dio.get('/cities', queryParameters: params);
    final dataList = response.data['data'] as List? ?? [];
    return dataList.map((r) => CityItem.fromJsonApi(r)).toList();
  }
}

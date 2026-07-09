import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/namaz_time.dart';

/// Dio-based service for fetching namaz-time content (the static
/// masail/fazail text screens) from the .NET REST API.
///
/// The .NET `GET /api/namaz-times` list endpoint only supports
/// `page/pageSize/search` — there is no `slug` or `position` filter like
/// the legacy Ruby API had. There are only ~10 fixed prayer-period entries
/// though, so callers fetch the full list once (see
/// `namazTimeListProvider`) and resolve a specific item by its position in
/// that list rather than querying the API per-slug.
class NamazTimeApiService {
  late final Dio _dio;

  NamazTimeApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.env['DOTNET_API_HOST_NAME']}/api',
      ),
    );
  }

  /// Fetch the full namaz-time list, ordered by `position` (server-side
  /// default ordering — see `NamazTimeService.GetListAsync`).
  Future<List<NamazTimeListItem>> fetchAll() async {
    final response = await _dio.get(
      '/namaz-times',
      queryParameters: {
        'page': 1,
        'pageSize': 50,
      },
    );
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => NamazTimeListItem.fromJson(r)).toList();
  }

  /// Fetch the full detail (masail/fazail text) for a single namaz time.
  Future<NamazTimeItem> fetchById(String id) async {
    final response = await _dio.get('/namaz-times/$id');
    return NamazTimeItem.fromJson(response.data);
  }
}

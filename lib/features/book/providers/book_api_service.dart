import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/book.dart';
import '../models/book_author.dart';
import '../models/book_chapter.dart';
import '../models/book_subchapter.dart';
import '../models/book_category.dart';

/// Dio-based service for fetching books from the JSON:API backend.
/// Replaces the Flutter Data Repository + JSONAPIAdapter stack.
class BookApiService {
  late final Dio _dio;

  BookApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_HOST_NAME']}/api',
      headers: {'Accept': 'application/vnd.api+json'},
    ));
  }

  // ───────────────────── Books ─────────────────────

  Future<List<Book>> fetchBooks({
    int page = 1,
    int perPage = 20,
    String? search,
    String? authorId,
    String? bookCategoryId,
    String? bookSubcategoryId,
    bool includeAuthors = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'published': true,
      if (includeAuthors) 'include': 'authors',
      if (search != null && search.isNotEmpty) 'search': search,
      if (authorId != null) 'authorId': authorId,
      if (bookCategoryId != null) 'bookCategoryId': bookCategoryId,
      if (bookSubcategoryId != null) 'bookSubcategoryId': bookSubcategoryId,
    };

    final response = await _dio.get('/books', queryParameters: params);
    debugPrint(
        '[BookApiService] fetchBooks response status: ${response.statusCode}');
    return _parseBooksResponse(response.data);
  }

  Future<Book> fetchBook(String id, {bool includeAuthors = true}) async {
    final params = <String, dynamic>{
      if (includeAuthors) 'include': 'authors',
    };

    final response = await _dio.get('/books/$id', queryParameters: params);
    debugPrint(
        '[BookApiService] fetchBook($id) response status: ${response.statusCode}');
    return _parseSingleBookResponse(response.data);
  }

  // ───────────────────── Chapters ─────────────────────

  Future<List<BookChapter>> fetchChapters({
    required String bookId,
    int? quantity,
    String? sort,
    int? position,
    bool includeSubchapters = false,
  }) async {
    final params = <String, dynamic>{
      'bookId': bookId,
      if (quantity != null) 'quantity': quantity,
      if (sort != null) 'sort': sort,
      if (position != null) 'position': position,
      if (includeSubchapters) 'include': 'subchapters',
    };

    final response = await _dio.get('/chapters', queryParameters: params);
    return _parseChaptersResponse(response.data);
  }

  Future<BookChapter> fetchChapter(String id) async {
    final response = await _dio.get('/chapters/$id');
    return _parseSingleChapterResponse(response.data);
  }

  // ───────────────────── Subchapters ─────────────────────

  Future<List<BookSubchapter>> fetchSubchapters({
    required String chapterId,
    int? quantity,
    int? position,
  }) async {
    final params = <String, dynamic>{
      'chapterId': chapterId,
      if (quantity != null) 'quantity': quantity,
      if (position != null) 'position': position,
    };

    final response = await _dio.get('/subchapters', queryParameters: params);
    return _parseSubchaptersResponse(response.data);
  }

  Future<BookSubchapter> fetchSubchapter(String id,
      {bool includeChapter = false}) async {
    final params = <String, dynamic>{
      if (includeChapter) 'include': 'chapter',
    };
    final response =
        await _dio.get('/subchapters/$id', queryParameters: params);
    return _parseSingleSubchapterResponse(response.data);
  }

  // ───────────────────── Authors (for filters) ─────────────────────

  Future<List<BookAuthor>> fetchAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dio.get('/authors', queryParameters: params);
    return _parseAuthorsResponse(response.data);
  }

  Future<BookAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/authors/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return BookAuthor.fromJsonApi(data);
  }

  // ───────────────────── Categories (for filters) ─────────────────────

  Future<List<BookCategory>> fetchBookCategories({
    int page = 1,
    int perPage = 16,
    bool includeSubcategories = true,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (includeSubcategories) 'include': 'book-subcategories',
    };

    final response =
        await _dio.get('/book_categories', queryParameters: params);
    return _parseCategoriesResponse(response.data);
  }

  Future<BookCategory> fetchBookCategory(String id) async {
    final response = await _dio.get('/book_categories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return BookCategory.fromJsonApi(data);
  }

  Future<BookSubcategory> fetchBookSubcategory(String id) async {
    final response = await _dio.get('/book_subcategories/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return BookSubcategory.fromJsonApi(data);
  }

  // ═══════════════════════════════════════════════
  //  JSON:API Response Parsing
  // ═══════════════════════════════════════════════

  /// Build a lookup map from the `included` array
  Map<String, Map<String, dynamic>> _buildIncludedMap(dynamic included) {
    final map = <String, Map<String, dynamic>>{};
    if (included is List) {
      for (final item in included) {
        final type = item['type']?.toString() ?? '';
        final id = item['id']?.toString() ?? '';
        map['$type:$id'] = item as Map<String, dynamic>;
      }
    }
    return map;
  }

  /// Resolve relationship IDs from a resource's relationships object
  List<String> _resolveRelIds(Map<String, dynamic> resource, String relName) {
    final rels = resource['relationships'] as Map<String, dynamic>?;
    if (rels == null || !rels.containsKey(relName)) return [];
    final relData = rels[relName]['data'];
    if (relData is List) {
      return relData.map((r) => r['id'].toString()).toList();
    } else if (relData is Map) {
      return [relData['id'].toString()];
    }
    return [];
  }

  String? _resolveSingleRelId(Map<String, dynamic> resource, String relName) {
    final ids = _resolveRelIds(resource, relName);
    return ids.isNotEmpty ? ids.first : null;
  }

  // ─── Books parsing ───

  List<Book> _parseBooksResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final authorIds = _resolveRelIds(resource, 'authors');
      final authors = authorIds
          .map((id) => included['authors:$id'])
          .where((a) => a != null)
          .map((a) => BookAuthor.fromJsonApi(a!))
          .toList();

      return Book.fromJsonApi(resource, resolvedAuthors: authors);
    }).toList();
  }

  Book _parseSingleBookResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    final authorIds = _resolveRelIds(resource, 'authors');
    final authors = authorIds
        .map((id) => included['authors:$id'])
        .where((a) => a != null)
        .map((a) => BookAuthor.fromJsonApi(a!))
        .toList();

    return Book.fromJsonApi(resource, resolvedAuthors: authors);
  }

  // ─── Chapters parsing ───

  List<BookChapter> _parseChaptersResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final subchapterIds = _resolveRelIds(resource, 'subchapters');
      final subchapters = subchapterIds
          .map((id) => included['subchapters:$id'])
          .where((s) => s != null)
          .map((s) => BookSubchapter.fromJsonApi(s!))
          .toList();

      return BookChapter.fromJsonApi(resource,
          resolvedSubchapters: subchapters);
    }).toList();
  }

  BookChapter _parseSingleChapterResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    final subchapterIds = _resolveRelIds(resource, 'subchapters');
    final subchapters = subchapterIds
        .map((id) => included['subchapters:$id'])
        .where((s) => s != null)
        .map((s) => BookSubchapter.fromJsonApi(s!))
        .toList();

    return BookChapter.fromJsonApi(resource, resolvedSubchapters: subchapters);
  }

  // ─── Subchapters parsing ───

  List<BookSubchapter> _parseSubchaptersResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList
        .map((resource) => BookSubchapter.fromJsonApi(resource))
        .toList();
  }

  BookSubchapter _parseSingleSubchapterResponse(Map<String, dynamic> json) {
    final resource = json['data'] as Map<String, dynamic>;
    final included = _buildIncludedMap(json['included']);

    BookSubchapterParentChapter? chapter;
    final chapterId = _resolveSingleRelId(resource, 'chapter');
    if (chapterId != null) {
      final chapterResource = included['chapters:$chapterId'];
      if (chapterResource != null) {
        final attrs =
            chapterResource['attributes'] as Map<String, dynamic>? ?? {};
        chapter = BookSubchapterParentChapter(
          id: chapterId,
          position: attrs['position'] is int ? attrs['position'] : null,
        );
      } else {
        chapter = BookSubchapterParentChapter(id: chapterId);
      }
    }

    return BookSubchapter.fromJsonApi(resource, resolvedChapter: chapter);
  }

  // ─── Authors parsing ───

  List<BookAuthor> _parseAuthorsResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return dataList.map((r) => BookAuthor.fromJsonApi(r)).toList();
  }

  // ─── Categories parsing ───

  List<BookCategory> _parseCategoriesResponse(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    final included = _buildIncludedMap(json['included']);

    return dataList.map((resource) {
      final subcatIds = _resolveRelIds(resource, 'book-subcategories');
      final subcategories = subcatIds
          .map((id) => included['book_subcategories:$id'])
          .where((s) => s != null)
          .map((s) => BookSubcategory.fromJsonApi(s!))
          .toList();

      return BookCategory.fromJsonApi(resource,
          resolvedSubcategories: subcategories);
    }).toList();
  }
}

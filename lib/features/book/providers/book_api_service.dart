import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/book.dart';
import '../models/book_author.dart';
import '../models/book_chapter.dart';
import '../models/book_subchapter.dart';
import '../models/book_category.dart';

/// Dio-based service for fetching books from the .NET API (plain JSON).
class BookApiService {
  late final Dio _dio;

  BookApiService() {
    final baseUrl = '${dotenv.env['DOTNET_API_HOST_NAME']}/api';
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    debugPrint('[BookApiService] baseUrl=$baseUrl');
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('[BookApiService] → ${options.method} ${options.uri}');
          handler.next(options);
        },
        onError: (DioException e, handler) {
          debugPrint('[BookApiService] ✗ ${e.type.name} status=${e.response?.statusCode}');
          debugPrint('[BookApiService]   url=${e.requestOptions.uri}');
          debugPrint('[BookApiService]   responseHeaders=${e.response?.headers.map}');
          debugPrint('[BookApiService]   responseBody=${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }

  // ───────────────────── Books ─────────────────────

  Future<List<Book>> fetchBooks({
    int page = 1,
    int perPage = 20,
    String? search,
    String? authorId,
    String? categoryId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': perPage,
      'published': true,
      if (search != null && search.isNotEmpty) 'search': search,
      if (authorId != null) 'authorId': authorId,
      if (categoryId != null) 'categoryId': categoryId,
    };

    final response = await _dio.get('/books', queryParameters: params);
    debugPrint(
      '[BookApiService] fetchBooks response status: ${response.statusCode}',
    );
    final data = response.data['data'] as List? ?? [];
    return data.map((r) => Book.fromJson(r)).toList();
  }

  Future<Book> fetchBook(String id) async {
    final response = await _dio.get('/books/$id');
    debugPrint(
      '[BookApiService] fetchBook($id) response status: ${response.statusCode}',
    );
    return Book.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Chapters ─────────────────────

  /// Fetch the full chapter (+ nested subchapter) tree for a book in one call.
  Future<List<BookChapter>> fetchChaptersByBook(String bookId) async {
    final response = await _dio.get('/books/$bookId/chapters');
    final data = response.data as List? ?? [];
    return data.map((r) => BookChapter.fromJson(r)).toList();
  }

  Future<BookChapter> fetchChapter(String id) async {
    final response = await _dio.get('/chapters/$id');
    return BookChapter.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Subchapters ─────────────────────

  Future<BookSubchapter> fetchSubchapter(String id) async {
    final response = await _dio.get('/subchapters/$id');
    return BookSubchapter.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Authors (for filters) ─────────────────────

  Future<List<BookAuthor>> fetchAuthors({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'published': true,
      'page': page,
      'pageSize': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response = await _dio.get('/books/authors', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => BookAuthor.fromJson(r)).toList();
  }

  Future<BookAuthor> fetchAuthor(String id) async {
    final response = await _dio.get('/authors/$id');
    return BookAuthor.fromJson(response.data as Map<String, dynamic>);
  }

  // ───────────────────── Categories (for filters) ─────────────────────

  Future<List<BookCategory>> fetchBookCategories({
    int page = 1,
    int perPage = 16,
    String? search,
  }) async {
    final params = <String, dynamic>{
      'published': true,
      'page': page,
      'pageSize': perPage,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final response =
        await _dio.get('/books/categories', queryParameters: params);
    final data = response.data as List? ?? [];
    return data.map((r) => BookCategory.fromJson(r)).toList();
  }

  Future<BookCategory> fetchBookCategory(String id) async {
    final response = await _dio.get('/categories/$id');
    return BookCategory.fromJson(response.data as Map<String, dynamic>);
  }
}

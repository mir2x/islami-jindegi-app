import 'package:dio/dio.dart';

/// A local copy is a resilience fallback, not an alternative authorization
/// path. In particular, do not turn a public 404 for unpublished content into
/// a successful read from stale SQLite data.
bool shouldFallbackToOffline(Object error) =>
    error is DioException &&
    (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout);

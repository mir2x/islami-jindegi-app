import 'dart:convert';
import 'book_author.dart';

class Book {
  final String id;
  final String title;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final String language;
  final Map<dynamic, dynamic>? image;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<BookAuthor> authors;

  Book({
    required this.id,
    required this.title,
    this.excerpt,
    this.publisher,
    this.price,
    required this.language,
    this.image,
    this.document,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.authors = const [],
  });

  /// Parse from JSON:API primary data resource + resolved included authors
  factory Book.fromJsonApi(
    Map<String, dynamic> resource, {
    List<BookAuthor> resolvedAuthors = const [],
  }) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};

    return Book(
      id: resource['id'].toString(),
      title: attrs['title'] ?? '',
      excerpt: attrs['excerpt'],
      publisher: attrs['publisher'],
      price: attrs['price'],
      language: attrs['language'] ?? '',
      image: _parseMapAttr(attrs['image']),
      document: _parseMapAttr(attrs['document']),
      position: attrs['position'] is int ? attrs['position'] : null,
      published: attrs['published'],
      publishedAt: attrs['published-at'],
      createdAt: attrs['created-at'],
      updatedAt: attrs['updated-at'],
      authors: resolvedAuthors,
    );
  }

  /// Parse from local SQLite row + pre-joined authors
  factory Book.fromDb(
    Map<String, dynamic> row, {
    List<BookAuthor> authors = const [],
  }) {
    return Book(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      excerpt: row['excerpt'],
      publisher: row['publisher'],
      price: row['price'],
      language: row['language'] ?? '',
      image: _decodeJsonColumn(row['image_data'] ?? row['imageData']),
      document: _decodeJsonColumn(row['document_data'] ?? row['documentData']),
      position: row['position'] is int ? row['position'] : null,
      publishedAt: row['published_at'] ?? row['publishedAt'],
      createdAt: row['created_at'] ?? row['createdAt'],
      updatedAt: row['updated_at'] ?? row['updatedAt'],
      authors: authors,
    );
  }

  static Map<dynamic, dynamic>? _parseMapAttr(dynamic value) {
    if (value is Map) return value;
    if (value is String) {
      try {
        return json.decode(value) as Map;
      } catch (_) {}
    }
    return null;
  }

  static Map<dynamic, dynamic>? _decodeJsonColumn(dynamic value) {
    if (value == null) return null;
    if (value is Map) return value;
    if (value is String) {
      try {
        return json.decode(value) as Map;
      } catch (_) {}
    }
    return null;
  }
}

import 'book_author.dart';
import 'book_category.dart';

class Book {
  final String id;
  final String title;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final String language;
  final String? coverUrl;
  final String? documentUrl;
  final int? position;
  final bool? published;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<BookAuthor> authors;
  final List<BookCategory> categories;

  Book({
    required this.id,
    required this.title,
    this.excerpt,
    this.publisher,
    this.price,
    required this.language,
    this.coverUrl,
    this.documentUrl,
    this.position,
    this.published,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.authors = const [],
    this.categories = const [],
  });

  /// Parse from the .NET API's flat BookListItem/BookDetail JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      excerpt: json['excerpt'],
      publisher: json['publisher'],
      price: json['price'],
      language: json['language'] ?? '',
      coverUrl: json['coverUrl'],
      documentUrl: json['documentUrl'],
      position: json['position'] is int ? json['position'] : null,
      published: json['published'],
      publishedAt: json['publishedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      authors: (json['authors'] as List? ?? [])
          .map((a) => BookAuthor.fromJson(a))
          .toList(),
      categories: (json['categories'] as List? ?? [])
          .map((c) => BookCategory.fromJson(c))
          .toList(),
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
      coverUrl: row['cover_url'] ?? row['coverUrl'],
      documentUrl: row['document_url'] ?? row['documentUrl'],
      position: row['position'] is int ? row['position'] : null,
      publishedAt: row['published_at'] ?? row['publishedAt'],
      createdAt: row['created_at'] ?? row['createdAt'],
      updatedAt: row['updated_at'] ?? row['updatedAt'],
      authors: authors,
    );
  }
}

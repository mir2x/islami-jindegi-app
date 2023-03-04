import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_data_json_api_adapter/flutter_data_json_api_adapter.dart';
import 'package:native_app/adapters/application.dart';
import 'package:native_app/adapters/local_database.dart';
import 'author.dart';

part 'book.g.dart';

@JsonSerializable(fieldRename: FieldRename.kebab)
@DataRepository([JSONAPIAdapter, LocalDatabaseAdapter, ApplicationAdapter])
class Book extends DataModel<Book> {
  @override
  final String? id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final String language;
  final Map<dynamic, dynamic>? image;
  final Map<dynamic, dynamic>? document;
  final int? position;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  final HasMany<Author>? authors;

  Book({
    this.id,
    required this.title,
    required this.slug,
    this.excerpt,
    this.publisher,
    this.price,
    required this.language,
    this.image,
    this.document,
    this.position,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.authors,
  });
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Book extends DataClass implements Insertable<Book> {
  final String id;
  final String title;
  final String slug;
  final String? excerpt;
  final String? publisher;
  final String? price;
  final String language;
  final String? imageData;
  final String? documentData;
  final int position;
  final String? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Book(
      {required this.id,
      required this.title,
      required this.slug,
      this.excerpt,
      this.publisher,
      this.price,
      required this.language,
      this.imageData,
      this.documentData,
      required this.position,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || excerpt != null) {
      map['excerpt'] = Variable<String>(excerpt);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<String>(price);
    }
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || imageData != null) {
      map['image_data'] = Variable<String>(imageData);
    }
    if (!nullToAbsent || documentData != null) {
      map['document_data'] = Variable<String>(documentData);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<String>(publishedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  factory Book.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      excerpt: serializer.fromJson<String?>(json['excerpt']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      price: serializer.fromJson<String?>(json['price']),
      language: serializer.fromJson<String>(json['language']),
      imageData: serializer.fromJson<String?>(json['imageData']),
      documentData: serializer.fromJson<String?>(json['documentData']),
      position: serializer.fromJson<int>(json['position']),
      publishedAt: serializer.fromJson<String?>(json['publishedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'slug': serializer.toJson<String>(slug),
      'excerpt': serializer.toJson<String?>(excerpt),
      'publisher': serializer.toJson<String?>(publisher),
      'price': serializer.toJson<String?>(price),
      'language': serializer.toJson<String>(language),
      'imageData': serializer.toJson<String?>(imageData),
      'documentData': serializer.toJson<String?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<String?>(publishedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Book copyWith(
          {String? id,
          String? title,
          String? slug,
          Value<String?> excerpt = const Value.absent(),
          Value<String?> publisher = const Value.absent(),
          Value<String?> price = const Value.absent(),
          String? language,
          Value<String?> imageData = const Value.absent(),
          Value<String?> documentData = const Value.absent(),
          int? position,
          Value<String?> publishedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Book(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        excerpt: excerpt.present ? excerpt.value : this.excerpt,
        publisher: publisher.present ? publisher.value : this.publisher,
        price: price.present ? price.value : this.price,
        language: language ?? this.language,
        imageData: imageData.present ? imageData.value : this.imageData,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('excerpt: $excerpt, ')
          ..write('publisher: $publisher, ')
          ..write('price: $price, ')
          ..write('language: $language, ')
          ..write('imageData: $imageData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      slug,
      excerpt,
      publisher,
      price,
      language,
      imageData,
      documentData,
      position,
      publishedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.excerpt == this.excerpt &&
          other.publisher == this.publisher &&
          other.price == this.price &&
          other.language == this.language &&
          other.imageData == this.imageData &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> slug;
  final Value<String?> excerpt;
  final Value<String?> publisher;
  final Value<String?> price;
  final Value<String> language;
  final Value<String?> imageData;
  final Value<String?> documentData;
  final Value<int> position;
  final Value<String?> publishedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.excerpt = const Value.absent(),
    this.publisher = const Value.absent(),
    this.price = const Value.absent(),
    this.language = const Value.absent(),
    this.imageData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BooksCompanion.insert({
    required String id,
    required String title,
    required String slug,
    this.excerpt = const Value.absent(),
    this.publisher = const Value.absent(),
    this.price = const Value.absent(),
    required String language,
    this.imageData = const Value.absent(),
    this.documentData = const Value.absent(),
    required int position,
    this.publishedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Book> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? excerpt,
    Expression<String>? publisher,
    Expression<String>? price,
    Expression<String>? language,
    Expression<String>? imageData,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<String>? publishedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (excerpt != null) 'excerpt': excerpt,
      if (publisher != null) 'publisher': publisher,
      if (price != null) 'price': price,
      if (language != null) 'language': language,
      if (imageData != null) 'image_data': imageData,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BooksCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String?>? excerpt,
      Value<String?>? publisher,
      Value<String?>? price,
      Value<String>? language,
      Value<String?>? imageData,
      Value<String?>? documentData,
      Value<int>? position,
      Value<String?>? publishedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      excerpt: excerpt ?? this.excerpt,
      publisher: publisher ?? this.publisher,
      price: price ?? this.price,
      language: language ?? this.language,
      imageData: imageData ?? this.imageData,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (excerpt.present) {
      map['excerpt'] = Variable<String>(excerpt.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (imageData.present) {
      map['image_data'] = Variable<String>(imageData.value);
    }
    if (documentData.present) {
      map['document_data'] = Variable<String>(documentData.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<String>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('excerpt: $excerpt, ')
          ..write('publisher: $publisher, ')
          ..write('price: $price, ')
          ..write('language: $language, ')
          ..write('imageData: $imageData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> excerpt = GeneratedColumn<String>(
      'excerpt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
      'publisher', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
      'price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> imageData = GeneratedColumn<String>(
      'image_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> publishedAt = GeneratedColumn<String>(
      'published_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        slug,
        excerpt,
        publisher,
        price,
        language,
        imageData,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'books';
  @override
  String get actualTableName => 'books';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      excerpt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}excerpt']),
      publisher: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}publisher']),
      price: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}price']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      imageData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}image_data']),
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String title;
  final String? body;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String bookId;
  const Chapter(
      {required this.id,
      required this.title,
      this.body,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.bookId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['book_id'] = Variable<String>(bookId);
    return map;
  }

  factory Chapter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      bookId: serializer.fromJson<String>(json['bookId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'bookId': serializer.toJson<String>(bookId),
    };
  }

  Chapter copyWith(
          {String? id,
          String? title,
          Value<String?> body = const Value.absent(),
          int? position,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? bookId}) =>
      Chapter(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body.present ? body.value : this.body,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        bookId: bookId ?? this.bookId,
      );
  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('bookId: $bookId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, position, createdAt, updatedAt, bookId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.bookId == this.bookId);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> body;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> bookId;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.bookId = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String title,
    this.body = const Value.absent(),
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String bookId,
  })  : id = Value(id),
        title = Value(title),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        bookId = Value(bookId);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? bookId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (bookId != null) 'book_id': bookId,
    });
  }

  ChaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? body,
      Value<int>? position,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? bookId}) {
    return ChaptersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bookId: bookId ?? this.bookId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('bookId: $bookId')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES books (id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, position, createdAt, updatedAt, bookId];
  @override
  String get aliasedName => _alias ?? 'chapters';
  @override
  String get actualTableName => 'chapters';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      bookId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Subchapter extends DataClass implements Insertable<Subchapter> {
  final String id;
  final String title;
  final String body;
  final int position;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String chapterId;
  const Subchapter(
      {required this.id,
      required this.title,
      required this.body,
      required this.position,
      required this.createdAt,
      required this.updatedAt,
      required this.chapterId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['position'] = Variable<int>(position);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['chapter_id'] = Variable<String>(chapterId);
    return map;
  }

  factory Subchapter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subchapter(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      position: serializer.fromJson<int>(json['position']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'position': serializer.toJson<int>(position),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'chapterId': serializer.toJson<String>(chapterId),
    };
  }

  Subchapter copyWith(
          {String? id,
          String? title,
          String? body,
          int? position,
          DateTime? createdAt,
          DateTime? updatedAt,
          String? chapterId}) =>
      Subchapter(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        chapterId: chapterId ?? this.chapterId,
      );
  @override
  String toString() {
    return (StringBuffer('Subchapter(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('chapterId: $chapterId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, body, position, createdAt, updatedAt, chapterId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subchapter &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.position == this.position &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.chapterId == this.chapterId);
}

class SubchaptersCompanion extends UpdateCompanion<Subchapter> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<int> position;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> chapterId;
  const SubchaptersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.position = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.chapterId = const Value.absent(),
  });
  SubchaptersCompanion.insert({
    required String id,
    required String title,
    required String body,
    required int position,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String chapterId,
  })  : id = Value(id),
        title = Value(title),
        body = Value(body),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        chapterId = Value(chapterId);
  static Insertable<Subchapter> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? position,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? chapterId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (position != null) 'position': position,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (chapterId != null) 'chapter_id': chapterId,
    });
  }

  SubchaptersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<int>? position,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<String>? chapterId}) {
    return SubchaptersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      chapterId: chapterId ?? this.chapterId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubchaptersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('position: $position, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('chapterId: $chapterId')
          ..write(')'))
        .toString();
  }
}

class $SubchaptersTable extends Subchapters
    with TableInfo<$SubchaptersTable, Subchapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubchaptersTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES chapters (id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, position, createdAt, updatedAt, chapterId];
  @override
  String get aliasedName => _alias ?? 'subchapters';
  @override
  String get actualTableName => 'subchapters';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subchapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subchapter(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      chapterId: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
    );
  }

  @override
  $SubchaptersTable createAlias(String alias) {
    return $SubchaptersTable(attachedDatabase, alias);
  }
}

class Masail extends DataClass implements Insertable<Masail> {
  final String id;
  final String title;
  final String slug;
  final String question;
  final String? answer;
  final String language;
  final bool hasAudio;
  final String? audioData;
  final String? documentData;
  final int position;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Masail(
      {required this.id,
      required this.title,
      required this.slug,
      required this.question,
      this.answer,
      required this.language,
      required this.hasAudio,
      this.audioData,
      this.documentData,
      required this.position,
      this.publishedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    map['question'] = Variable<String>(question);
    if (!nullToAbsent || answer != null) {
      map['answer'] = Variable<String>(answer);
    }
    map['language'] = Variable<String>(language);
    map['has_audio'] = Variable<bool>(hasAudio);
    if (!nullToAbsent || audioData != null) {
      map['audio_data'] = Variable<String>(audioData);
    }
    if (!nullToAbsent || documentData != null) {
      map['document_data'] = Variable<String>(documentData);
    }
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  factory Masail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Masail(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String?>(json['answer']),
      language: serializer.fromJson<String>(json['language']),
      hasAudio: serializer.fromJson<bool>(json['hasAudio']),
      audioData: serializer.fromJson<String?>(json['audioData']),
      documentData: serializer.fromJson<String?>(json['documentData']),
      position: serializer.fromJson<int>(json['position']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'slug': serializer.toJson<String>(slug),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String?>(answer),
      'language': serializer.toJson<String>(language),
      'hasAudio': serializer.toJson<bool>(hasAudio),
      'audioData': serializer.toJson<String?>(audioData),
      'documentData': serializer.toJson<String?>(documentData),
      'position': serializer.toJson<int>(position),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Masail copyWith(
          {String? id,
          String? title,
          String? slug,
          String? question,
          Value<String?> answer = const Value.absent(),
          String? language,
          bool? hasAudio,
          Value<String?> audioData = const Value.absent(),
          Value<String?> documentData = const Value.absent(),
          int? position,
          Value<DateTime?> publishedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Masail(
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        question: question ?? this.question,
        answer: answer.present ? answer.value : this.answer,
        language: language ?? this.language,
        hasAudio: hasAudio ?? this.hasAudio,
        audioData: audioData.present ? audioData.value : this.audioData,
        documentData:
            documentData.present ? documentData.value : this.documentData,
        position: position ?? this.position,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('Masail(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      slug,
      question,
      answer,
      language,
      hasAudio,
      audioData,
      documentData,
      position,
      publishedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Masail &&
          other.id == this.id &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.language == this.language &&
          other.hasAudio == this.hasAudio &&
          other.audioData == this.audioData &&
          other.documentData == this.documentData &&
          other.position == this.position &&
          other.publishedAt == this.publishedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MasailsCompanion extends UpdateCompanion<Masail> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> slug;
  final Value<String> question;
  final Value<String?> answer;
  final Value<String> language;
  final Value<bool> hasAudio;
  final Value<String?> audioData;
  final Value<String?> documentData;
  final Value<int> position;
  final Value<DateTime?> publishedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MasailsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.language = const Value.absent(),
    this.hasAudio = const Value.absent(),
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    this.position = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MasailsCompanion.insert({
    required String id,
    required String title,
    required String slug,
    required String question,
    this.answer = const Value.absent(),
    required String language,
    this.hasAudio = const Value.absent(),
    this.audioData = const Value.absent(),
    this.documentData = const Value.absent(),
    required int position,
    this.publishedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : id = Value(id),
        title = Value(title),
        slug = Value(slug),
        question = Value(question),
        language = Value(language),
        position = Value(position),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Masail> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<String>? language,
    Expression<bool>? hasAudio,
    Expression<String>? audioData,
    Expression<String>? documentData,
    Expression<int>? position,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (language != null) 'language': language,
      if (hasAudio != null) 'has_audio': hasAudio,
      if (audioData != null) 'audio_data': audioData,
      if (documentData != null) 'document_data': documentData,
      if (position != null) 'position': position,
      if (publishedAt != null) 'published_at': publishedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MasailsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? slug,
      Value<String>? question,
      Value<String?>? answer,
      Value<String>? language,
      Value<bool>? hasAudio,
      Value<String?>? audioData,
      Value<String?>? documentData,
      Value<int>? position,
      Value<DateTime?>? publishedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MasailsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      language: language ?? this.language,
      hasAudio: hasAudio ?? this.hasAudio,
      audioData: audioData ?? this.audioData,
      documentData: documentData ?? this.documentData,
      position: position ?? this.position,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (hasAudio.present) {
      map['has_audio'] = Variable<bool>(hasAudio.value);
    }
    if (audioData.present) {
      map['audio_data'] = Variable<String>(audioData.value);
    }
    if (documentData.present) {
      map['document_data'] = Variable<String>(documentData.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MasailsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('language: $language, ')
          ..write('hasAudio: $hasAudio, ')
          ..write('audioData: $audioData, ')
          ..write('documentData: $documentData, ')
          ..write('position: $position, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MasailsTable extends Masails with TableInfo<$MasailsTable, Masail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasailsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<bool> hasAudio = GeneratedColumn<bool>(
      'has_audio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (has_audio IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<String> audioData = GeneratedColumn<String>(
      'audio_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> documentData = GeneratedColumn<String>(
      'document_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        slug,
        question,
        answer,
        language,
        hasAudio,
        audioData,
        documentData,
        position,
        publishedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'masails';
  @override
  String get actualTableName => 'masails';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Masail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Masail(
      id: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      question: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}answer']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      hasAudio: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}has_audio'])!,
      audioData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}audio_data']),
      documentData: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}document_data']),
      position: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      publishedAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at']),
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MasailsTable createAlias(String alias) {
    return $MasailsTable(attachedDatabase, alias);
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  late final $BooksTable books = $BooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $SubchaptersTable subchapters = $SubchaptersTable(this);
  late final $MasailsTable masails = $MasailsTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [books, chapters, subchapters, masails];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $BookLocalAdapter on LocalAdapter<Book> {
  static final Map<String, RelationshipMeta> _kBookRelationshipMetas = {
    'authors': RelationshipMeta<Author>(
      name: 'authors',
      type: 'authors',
      kind: 'HasMany',
      instance: (_) => (_ as Book).authors,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kBookRelationshipMetas;

  @override
  Book deserialize(map) {
    map = transformDeserialize(map);
    return _$BookFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$BookToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _booksFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $BookHiveLocalAdapter = HiveLocalAdapter<Book> with $BookLocalAdapter;

class $BookRemoteAdapter = RemoteAdapter<Book>
    with
        JSONAPIAdapter<Book>,
        LocalDatabaseAdapter<Book>,
        ApplicationAdapter<Book>;

final internalBooksRemoteAdapterProvider = Provider<RemoteAdapter<Book>>(
    (ref) => $BookRemoteAdapter(
        $BookHiveLocalAdapter(ref), InternalHolder(_booksFinders)));

final booksRepositoryProvider =
    Provider<Repository<Book>>((ref) => Repository<Book>(ref));

extension BookDataRepositoryX on Repository<Book> {
  JSONAPIAdapter<Book> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Book>;
  LocalDatabaseAdapter<Book> get localDatabaseAdapter =>
      remoteAdapter as LocalDatabaseAdapter<Book>;
  ApplicationAdapter<Book> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Book>;
}

extension BookRelationshipGraphNodeX on RelationshipGraphNode<Book> {
  RelationshipGraphNode<Author> get authors {
    final meta = $BookLocalAdapter._kBookRelationshipMetas['authors']
        as RelationshipMeta<Author>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String?,
      publisher: json['publisher'] as String?,
      price: json['price'] as String?,
      language: json['language'] as String,
      image: json['image'] as Map<dynamic, dynamic>?,
      document: json['document'] as Map<dynamic, dynamic>?,
      position: json['position'] as int?,
      publishedAt: json['published-at'] as String?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      authors: json['authors'] == null
          ? null
          : HasMany<Author>.fromJson(json['authors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'publisher': instance.publisher,
      'price': instance.price,
      'language': instance.language,
      'image': instance.image,
      'document': instance.document,
      'position': instance.position,
      'published-at': instance.publishedAt,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'authors': instance.authors,
    };

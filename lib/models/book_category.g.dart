// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_category.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $BookCategoryLocalAdapter on LocalAdapter<BookCategory> {
  static final Map<String, RelationshipMeta> _kBookCategoryRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kBookCategoryRelationshipMetas;

  @override
  BookCategory deserialize(map) {
    map = transformDeserialize(map);
    return _$BookCategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$BookCategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _bookCategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $BookCategoryHiveLocalAdapter = HiveLocalAdapter<BookCategory>
    with $BookCategoryLocalAdapter;

class $BookCategoryRemoteAdapter = RemoteAdapter<BookCategory>
    with JSONAPIAdapter<BookCategory>, ApplicationAdapter<BookCategory>;

final internalBookCategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<BookCategory>>((ref) => $BookCategoryRemoteAdapter(
        $BookCategoryHiveLocalAdapter(ref.read, typeId: null),
        InternalHolder(_bookCategoriesFinders)));

final bookCategoriesRepositoryProvider = Provider<Repository<BookCategory>>(
    (ref) => Repository<BookCategory>(ref.read));

extension BookCategoryDataRepositoryX on Repository<BookCategory> {
  JSONAPIAdapter<BookCategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<BookCategory>;
  ApplicationAdapter<BookCategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<BookCategory>;
}

extension BookCategoryRelationshipGraphNodeX
    on RelationshipGraphNode<BookCategory> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookCategory _$BookCategoryFromJson(Map<String, dynamic> json) => BookCategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$BookCategoryToJson(BookCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

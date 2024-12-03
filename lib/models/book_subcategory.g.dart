// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_subcategory.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $BookSubcategoryLocalAdapter on LocalAdapter<BookSubcategory> {
  static final Map<String, RelationshipMeta>
      _kBookSubcategoryRelationshipMetas = {
    'book-category': RelationshipMeta<BookCategory>(
      name: 'bookCategory',
      inverseName: 'bookSubcategories',
      type: 'bookCategories',
      kind: 'BelongsTo',
      instance: (_) => (_ as BookSubcategory).bookCategory,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kBookSubcategoryRelationshipMetas;

  @override
  BookSubcategory deserialize(map) {
    map = transformDeserialize(map);
    return _$BookSubcategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$BookSubcategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _bookSubcategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $BookSubcategoryHiveLocalAdapter = HiveLocalAdapter<BookSubcategory>
    with $BookSubcategoryLocalAdapter;

class $BookSubcategoryRemoteAdapter = RemoteAdapter<BookSubcategory>
    with JSONAPIAdapter<BookSubcategory>, ApplicationAdapter<BookSubcategory>;

final internalBookSubcategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<BookSubcategory>>((ref) =>
        $BookSubcategoryRemoteAdapter($BookSubcategoryHiveLocalAdapter(ref),
            InternalHolder(_bookSubcategoriesFinders)));

final bookSubcategoriesRepositoryProvider =
    Provider<Repository<BookSubcategory>>(
        (ref) => Repository<BookSubcategory>(ref));

extension BookSubcategoryDataRepositoryX on Repository<BookSubcategory> {
  JSONAPIAdapter<BookSubcategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<BookSubcategory>;
  ApplicationAdapter<BookSubcategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<BookSubcategory>;
}

extension BookSubcategoryRelationshipGraphNodeX
    on RelationshipGraphNode<BookSubcategory> {
  RelationshipGraphNode<BookCategory> get bookCategory {
    final meta = $BookSubcategoryLocalAdapter
            ._kBookSubcategoryRelationshipMetas['book-category']
        as RelationshipMeta<BookCategory>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookSubcategory _$BookSubcategoryFromJson(Map<String, dynamic> json) =>
    BookSubcategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      position: (json['position'] as num?)?.toInt(),
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      bookCategory: json['book-category'] == null
          ? null
          : BelongsTo<BookCategory>.fromJson(
              json['book-category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookSubcategoryToJson(BookSubcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'book-category': instance.bookCategory,
    };

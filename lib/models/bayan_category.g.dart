// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bayan_category.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $BayanCategoryLocalAdapter on LocalAdapter<BayanCategory> {
  static final Map<String, RelationshipMeta> _kBayanCategoryRelationshipMetas =
      {
    'book-subcategories': RelationshipMeta<BookSubcategory>(
      name: 'bookSubcategories',
      type: 'bookSubcategories',
      kind: 'HasMany',
      instance: (_) => (_ as BayanCategory).bookSubcategories,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kBayanCategoryRelationshipMetas;

  @override
  BayanCategory deserialize(map) {
    map = transformDeserialize(map);
    return _$BayanCategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$BayanCategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _bayanCategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $BayanCategoryHiveLocalAdapter = HiveLocalAdapter<BayanCategory>
    with $BayanCategoryLocalAdapter;

class $BayanCategoryRemoteAdapter = RemoteAdapter<BayanCategory>
    with JSONAPIAdapter<BayanCategory>, ApplicationAdapter<BayanCategory>;

final internalBayanCategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<BayanCategory>>(
  (ref) => $BayanCategoryRemoteAdapter(
    $BayanCategoryHiveLocalAdapter(ref.read, typeId: null),
    InternalHolder(_bayanCategoriesFinders),
  ),
);

final bayanCategoriesRepositoryProvider = Provider<Repository<BayanCategory>>(
  (ref) => Repository<BayanCategory>(ref.read),
);

extension BayanCategoryDataRepositoryX on Repository<BayanCategory> {
  JSONAPIAdapter<BayanCategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<BayanCategory>;
  ApplicationAdapter<BayanCategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<BayanCategory>;
}

extension BayanCategoryRelationshipGraphNodeX
    on RelationshipGraphNode<BayanCategory> {
  RelationshipGraphNode<BookSubcategory> get bookSubcategories {
    final meta = $BayanCategoryLocalAdapter
            ._kBayanCategoryRelationshipMetas['book-subcategories']
        as RelationshipMeta<BookSubcategory>;
    return meta.clone(
      parent: this is RelationshipMeta ? this as RelationshipMeta : null,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BayanCategory _$BayanCategoryFromJson(Map<String, dynamic> json) =>
    BayanCategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      bookSubcategories: json['book-subcategories'] == null
          ? null
          : HasMany<BookSubcategory>.fromJson(
              json['book-subcategories'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$BayanCategoryToJson(BayanCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'book-subcategories': instance.bookSubcategories,
    };

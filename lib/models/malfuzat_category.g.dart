// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'malfuzat_category.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MalfuzatCategoryLocalAdapter on LocalAdapter<MalfuzatCategory> {
  static final Map<String, RelationshipMeta>
      _kMalfuzatCategoryRelationshipMetas = {
    'malfuzat-subcategories': RelationshipMeta<MalfuzatSubcategory>(
      name: 'malfuzatSubcategories',
      inverseName: 'malfuzatCategory',
      type: 'malfuzatSubcategories',
      kind: 'HasMany',
      instance: (_) => (_ as MalfuzatCategory).malfuzatSubcategories,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMalfuzatCategoryRelationshipMetas;

  @override
  MalfuzatCategory deserialize(map) {
    map = transformDeserialize(map);
    return _$MalfuzatCategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MalfuzatCategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _malfuzatCategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MalfuzatCategoryHiveLocalAdapter = HiveLocalAdapter<MalfuzatCategory>
    with $MalfuzatCategoryLocalAdapter;

class $MalfuzatCategoryRemoteAdapter = RemoteAdapter<MalfuzatCategory>
    with JSONAPIAdapter<MalfuzatCategory>, ApplicationAdapter<MalfuzatCategory>;

final internalMalfuzatCategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<MalfuzatCategory>>((ref) =>
        $MalfuzatCategoryRemoteAdapter($MalfuzatCategoryHiveLocalAdapter(ref),
            InternalHolder(_malfuzatCategoriesFinders)));

final malfuzatCategoriesRepositoryProvider =
    Provider<Repository<MalfuzatCategory>>(
        (ref) => Repository<MalfuzatCategory>(ref));

extension MalfuzatCategoryDataRepositoryX on Repository<MalfuzatCategory> {
  JSONAPIAdapter<MalfuzatCategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MalfuzatCategory>;
  ApplicationAdapter<MalfuzatCategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MalfuzatCategory>;
}

extension MalfuzatCategoryRelationshipGraphNodeX
    on RelationshipGraphNode<MalfuzatCategory> {
  RelationshipGraphNode<MalfuzatSubcategory> get malfuzatSubcategories {
    final meta = $MalfuzatCategoryLocalAdapter
            ._kMalfuzatCategoryRelationshipMetas['malfuzat-subcategories']
        as RelationshipMeta<MalfuzatSubcategory>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MalfuzatCategory _$MalfuzatCategoryFromJson(Map<String, dynamic> json) =>
    MalfuzatCategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      malfuzatSubcategories: json['malfuzat-subcategories'] == null
          ? null
          : HasMany<MalfuzatSubcategory>.fromJson(
              json['malfuzat-subcategories'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MalfuzatCategoryToJson(MalfuzatCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'malfuzat-subcategories': instance.malfuzatSubcategories,
    };

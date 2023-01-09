// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masail_category.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MasailCategoryLocalAdapter on LocalAdapter<MasailCategory> {
  static final Map<String, RelationshipMeta> _kMasailCategoryRelationshipMetas =
      {
    'masail-subcategories': RelationshipMeta<MasailSubcategory>(
      name: 'masailSubcategories',
      inverseName: 'masailCategory',
      type: 'masailSubcategories',
      kind: 'HasMany',
      instance: (_) => (_ as MasailCategory).masailSubcategories,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMasailCategoryRelationshipMetas;

  @override
  MasailCategory deserialize(map) {
    map = transformDeserialize(map);
    return _$MasailCategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MasailCategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _masailCategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MasailCategoryHiveLocalAdapter = HiveLocalAdapter<MasailCategory>
    with $MasailCategoryLocalAdapter;

class $MasailCategoryRemoteAdapter = RemoteAdapter<MasailCategory>
    with JSONAPIAdapter<MasailCategory>, ApplicationAdapter<MasailCategory>;

final internalMasailCategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<MasailCategory>>(
  (ref) => $MasailCategoryRemoteAdapter(
    $MasailCategoryHiveLocalAdapter(ref),
    InternalHolder(_masailCategoriesFinders),
  ),
);

final masailCategoriesRepositoryProvider = Provider<Repository<MasailCategory>>(
  (ref) => Repository<MasailCategory>(ref),
);

extension MasailCategoryDataRepositoryX on Repository<MasailCategory> {
  JSONAPIAdapter<MasailCategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MasailCategory>;
  ApplicationAdapter<MasailCategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MasailCategory>;
}

extension MasailCategoryRelationshipGraphNodeX
    on RelationshipGraphNode<MasailCategory> {
  RelationshipGraphNode<MasailSubcategory> get masailSubcategories {
    final meta = $MasailCategoryLocalAdapter
            ._kMasailCategoryRelationshipMetas['masail-subcategories']
        as RelationshipMeta<MasailSubcategory>;
    return meta.clone(
      parent: this is RelationshipMeta ? this as RelationshipMeta : null,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasailCategory _$MasailCategoryFromJson(Map<String, dynamic> json) =>
    MasailCategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      masailSubcategories: json['masail-subcategories'] == null
          ? null
          : HasMany<MasailSubcategory>.fromJson(
              json['masail-subcategories'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MasailCategoryToJson(MasailCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'masail-subcategories': instance.masailSubcategories,
    };

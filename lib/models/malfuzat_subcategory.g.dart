// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'malfuzat_subcategory.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MalfuzatSubcategoryLocalAdapter on LocalAdapter<MalfuzatSubcategory> {
  static final Map<String, RelationshipMeta>
      _kMalfuzatSubcategoryRelationshipMetas = {
    'malfuzat-category': RelationshipMeta<MalfuzatCategory>(
      name: 'malfuzatCategory',
      inverseName: 'malfuzatSubcategories',
      type: 'malfuzatCategories',
      kind: 'BelongsTo',
      instance: (_) => (_ as MalfuzatSubcategory).malfuzatCategory,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMalfuzatSubcategoryRelationshipMetas;

  @override
  MalfuzatSubcategory deserialize(map) {
    map = transformDeserialize(map);
    return _$MalfuzatSubcategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MalfuzatSubcategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _malfuzatSubcategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MalfuzatSubcategoryHiveLocalAdapter = HiveLocalAdapter<
    MalfuzatSubcategory> with $MalfuzatSubcategoryLocalAdapter;

class $MalfuzatSubcategoryRemoteAdapter = RemoteAdapter<MalfuzatSubcategory>
    with
        JSONAPIAdapter<MalfuzatSubcategory>,
        ApplicationAdapter<MalfuzatSubcategory>;

final internalMalfuzatSubcategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<MalfuzatSubcategory>>((ref) =>
        $MalfuzatSubcategoryRemoteAdapter(
            $MalfuzatSubcategoryHiveLocalAdapter(ref),
            InternalHolder(_malfuzatSubcategoriesFinders)));

final malfuzatSubcategoriesRepositoryProvider =
    Provider<Repository<MalfuzatSubcategory>>(
        (ref) => Repository<MalfuzatSubcategory>(ref));

extension MalfuzatSubcategoryDataRepositoryX
    on Repository<MalfuzatSubcategory> {
  JSONAPIAdapter<MalfuzatSubcategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MalfuzatSubcategory>;
  ApplicationAdapter<MalfuzatSubcategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MalfuzatSubcategory>;
}

extension MalfuzatSubcategoryRelationshipGraphNodeX
    on RelationshipGraphNode<MalfuzatSubcategory> {
  RelationshipGraphNode<MalfuzatCategory> get malfuzatCategory {
    final meta = $MalfuzatSubcategoryLocalAdapter
            ._kMalfuzatSubcategoryRelationshipMetas['malfuzat-category']
        as RelationshipMeta<MalfuzatCategory>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MalfuzatSubcategory _$MalfuzatSubcategoryFromJson(Map<String, dynamic> json) =>
    MalfuzatSubcategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      malfuzatCategory: json['malfuzat-category'] == null
          ? null
          : BelongsTo<MalfuzatCategory>.fromJson(
              json['malfuzat-category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MalfuzatSubcategoryToJson(
        MalfuzatSubcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'malfuzat-category': instance.malfuzatCategory,
    };

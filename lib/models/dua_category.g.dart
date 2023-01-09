// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_category.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $DuaCategoryLocalAdapter on LocalAdapter<DuaCategory> {
  static final Map<String, RelationshipMeta> _kDuaCategoryRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kDuaCategoryRelationshipMetas;

  @override
  DuaCategory deserialize(map) {
    map = transformDeserialize(map);
    return _$DuaCategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$DuaCategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _duaCategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $DuaCategoryHiveLocalAdapter = HiveLocalAdapter<DuaCategory>
    with $DuaCategoryLocalAdapter;

class $DuaCategoryRemoteAdapter = RemoteAdapter<DuaCategory>
    with JSONAPIAdapter<DuaCategory>, ApplicationAdapter<DuaCategory>;

final internalDuaCategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<DuaCategory>>(
  (ref) => $DuaCategoryRemoteAdapter(
    $DuaCategoryHiveLocalAdapter(ref),
    InternalHolder(_duaCategoriesFinders),
  ),
);

final duaCategoriesRepositoryProvider =
    Provider<Repository<DuaCategory>>((ref) => Repository<DuaCategory>(ref));

extension DuaCategoryDataRepositoryX on Repository<DuaCategory> {
  JSONAPIAdapter<DuaCategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<DuaCategory>;
  ApplicationAdapter<DuaCategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<DuaCategory>;
}

extension DuaCategoryRelationshipGraphNodeX
    on RelationshipGraphNode<DuaCategory> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DuaCategory _$DuaCategoryFromJson(Map<String, dynamic> json) => DuaCategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$DuaCategoryToJson(DuaCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

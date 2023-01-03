// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $DuaLocalAdapter on LocalAdapter<Dua> {
  static final Map<String, RelationshipMeta> _kDuaRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas => _kDuaRelationshipMetas;

  @override
  Dua deserialize(map) {
    map = transformDeserialize(map);
    return _$DuaFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$DuaToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _duasFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $DuaHiveLocalAdapter = HiveLocalAdapter<Dua> with $DuaLocalAdapter;

class $DuaRemoteAdapter = RemoteAdapter<Dua>
    with JSONAPIAdapter<Dua>, ApplicationAdapter<Dua>;

final internalDuasRemoteAdapterProvider = Provider<RemoteAdapter<Dua>>(
  (ref) => $DuaRemoteAdapter(
    $DuaHiveLocalAdapter(ref),
    InternalHolder(_duasFinders),
  ),
);

final duasRepositoryProvider =
    Provider<Repository<Dua>>((ref) => Repository<Dua>(ref));

extension DuaDataRepositoryX on Repository<Dua> {
  JSONAPIAdapter<Dua> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Dua>;
  ApplicationAdapter<Dua> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Dua>;
}

extension DuaRelationshipGraphNodeX on RelationshipGraphNode<Dua> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dua _$DuaFromJson(Map<String, dynamic> json) => Dua(
      id: json['id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      excerpt: json['excerpt'] as String?,
      language: json['language'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$DuaToJson(Dua instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'excerpt': instance.excerpt,
      'language': instance.language,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

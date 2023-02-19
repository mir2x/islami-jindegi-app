// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'malfuzat_author.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MalfuzatAuthorLocalAdapter on LocalAdapter<MalfuzatAuthor> {
  static final Map<String, RelationshipMeta> _kMalfuzatAuthorRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMalfuzatAuthorRelationshipMetas;

  @override
  MalfuzatAuthor deserialize(map) {
    map = transformDeserialize(map);
    return _$MalfuzatAuthorFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MalfuzatAuthorToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _malfuzatAuthorsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MalfuzatAuthorHiveLocalAdapter = HiveLocalAdapter<MalfuzatAuthor>
    with $MalfuzatAuthorLocalAdapter;

class $MalfuzatAuthorRemoteAdapter = RemoteAdapter<MalfuzatAuthor>
    with
        JSONAPIAdapter<MalfuzatAuthor>,
        LocalDatabaseAdapter<MalfuzatAuthor>,
        ApplicationAdapter<MalfuzatAuthor>;

final internalMalfuzatAuthorsRemoteAdapterProvider =
    Provider<RemoteAdapter<MalfuzatAuthor>>((ref) =>
        $MalfuzatAuthorRemoteAdapter($MalfuzatAuthorHiveLocalAdapter(ref),
            InternalHolder(_malfuzatAuthorsFinders)));

final malfuzatAuthorsRepositoryProvider = Provider<Repository<MalfuzatAuthor>>(
    (ref) => Repository<MalfuzatAuthor>(ref));

extension MalfuzatAuthorDataRepositoryX on Repository<MalfuzatAuthor> {
  JSONAPIAdapter<MalfuzatAuthor> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MalfuzatAuthor>;
  LocalDatabaseAdapter<MalfuzatAuthor> get localDatabaseAdapter =>
      remoteAdapter as LocalDatabaseAdapter<MalfuzatAuthor>;
  ApplicationAdapter<MalfuzatAuthor> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MalfuzatAuthor>;
}

extension MalfuzatAuthorRelationshipGraphNodeX
    on RelationshipGraphNode<MalfuzatAuthor> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MalfuzatAuthor _$MalfuzatAuthorFromJson(Map<String, dynamic> json) =>
    MalfuzatAuthor(
      id: json['id'] as String?,
      name: json['name'] as String,
      info: json['info'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$MalfuzatAuthorToJson(MalfuzatAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

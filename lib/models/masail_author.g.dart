// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masail_author.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MasailAuthorLocalAdapter on LocalAdapter<MasailAuthor> {
  static final Map<String, RelationshipMeta> _kMasailAuthorRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMasailAuthorRelationshipMetas;

  @override
  MasailAuthor deserialize(map) {
    map = transformDeserialize(map);
    return _$MasailAuthorFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MasailAuthorToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _masailAuthorsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MasailAuthorHiveLocalAdapter = HiveLocalAdapter<MasailAuthor>
    with $MasailAuthorLocalAdapter;

class $MasailAuthorRemoteAdapter = RemoteAdapter<MasailAuthor>
    with
        JSONAPIAdapter<MasailAuthor>,
        LocalDatabaseAdapter<MasailAuthor>,
        ApplicationAdapter<MasailAuthor>;

final internalMasailAuthorsRemoteAdapterProvider =
    Provider<RemoteAdapter<MasailAuthor>>((ref) => $MasailAuthorRemoteAdapter(
        $MasailAuthorHiveLocalAdapter(ref),
        InternalHolder(_masailAuthorsFinders)));

final masailAuthorsRepositoryProvider =
    Provider<Repository<MasailAuthor>>((ref) => Repository<MasailAuthor>(ref));

extension MasailAuthorDataRepositoryX on Repository<MasailAuthor> {
  JSONAPIAdapter<MasailAuthor> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MasailAuthor>;
  LocalDatabaseAdapter<MasailAuthor> get localDatabaseAdapter =>
      remoteAdapter as LocalDatabaseAdapter<MasailAuthor>;
  ApplicationAdapter<MasailAuthor> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MasailAuthor>;
}

extension MasailAuthorRelationshipGraphNodeX
    on RelationshipGraphNode<MasailAuthor> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasailAuthor _$MasailAuthorFromJson(Map<String, dynamic> json) => MasailAuthor(
      id: json['id'] as String?,
      name: json['name'] as String,
      info: json['info'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$MasailAuthorToJson(MasailAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

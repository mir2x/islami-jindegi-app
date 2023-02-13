// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'para.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $ParaLocalAdapter on LocalAdapter<Para> {
  static final Map<String, RelationshipMeta> _kParaRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kParaRelationshipMetas;

  @override
  Para deserialize(map) {
    map = transformDeserialize(map);
    return _$ParaFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$ParaToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _parasFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $ParaHiveLocalAdapter = HiveLocalAdapter<Para> with $ParaLocalAdapter;

class $ParaRemoteAdapter = RemoteAdapter<Para>
    with
        JSONAPIAdapter<Para>,
        LocalDatabaseAdapter<Para>,
        ApplicationAdapter<Para>;

final internalParasRemoteAdapterProvider = Provider<RemoteAdapter<Para>>(
    (ref) => $ParaRemoteAdapter(
        $ParaHiveLocalAdapter(ref), InternalHolder(_parasFinders)));

final parasRepositoryProvider =
    Provider<Repository<Para>>((ref) => Repository<Para>(ref));

extension ParaDataRepositoryX on Repository<Para> {
  JSONAPIAdapter<Para> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Para>;
  LocalDatabaseAdapter<Para> get localDatabaseAdapter =>
      remoteAdapter as LocalDatabaseAdapter<Para>;
  ApplicationAdapter<Para> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Para>;
}

extension ParaRelationshipGraphNodeX on RelationshipGraphNode<Para> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Para _$ParaFromJson(Map<String, dynamic> json) => Para(
      id: json['id'] as String?,
      title: json['title'] as String,
      titleBn: json['title-bn'] as String,
      slug: json['slug'] as String,
      totalAyat: json['total-ayat'] as int,
      totalRuku: json['total-ruku'] as int,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$ParaToJson(Para instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title-bn': instance.titleBn,
      'slug': instance.slug,
      'total-ayat': instance.totalAyat,
      'total-ruku': instance.totalRuku,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

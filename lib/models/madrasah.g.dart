// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'madrasah.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MadrasahLocalAdapter on LocalAdapter<Madrasah> {
  static final Map<String, RelationshipMeta> _kMadrasahRelationshipMetas = {
    'madrasah-infos': RelationshipMeta<MadrasahInfo>(
      name: 'madrasahInfos',
      inverseName: 'madrasah',
      type: 'madrasahInfos',
      kind: 'HasMany',
      instance: (_) => (_ as Madrasah).madrasahInfos,
    ),
    'madrasah-photos': RelationshipMeta<MadrasahPhoto>(
      name: 'madrasahPhotos',
      inverseName: 'madrasah',
      type: 'madrasahPhotos',
      kind: 'HasMany',
      instance: (_) => (_ as Madrasah).madrasahPhotos,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMadrasahRelationshipMetas;

  @override
  Madrasah deserialize(map) {
    map = transformDeserialize(map);
    return _$MadrasahFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MadrasahToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _madrasahsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MadrasahHiveLocalAdapter = HiveLocalAdapter<Madrasah>
    with $MadrasahLocalAdapter;

class $MadrasahRemoteAdapter = RemoteAdapter<Madrasah>
    with
        JSONAPIAdapter<Madrasah>,
        LocalDatabaseAdapter<Madrasah>,
        ApplicationAdapter<Madrasah>;

final internalMadrasahsRemoteAdapterProvider =
    Provider<RemoteAdapter<Madrasah>>((ref) => $MadrasahRemoteAdapter(
        $MadrasahHiveLocalAdapter(ref), InternalHolder(_madrasahsFinders)));

final madrasahsRepositoryProvider =
    Provider<Repository<Madrasah>>((ref) => Repository<Madrasah>(ref));

extension MadrasahDataRepositoryX on Repository<Madrasah> {
  JSONAPIAdapter<Madrasah> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Madrasah>;
  LocalDatabaseAdapter<Madrasah> get localDatabaseAdapter =>
      remoteAdapter as LocalDatabaseAdapter<Madrasah>;
  ApplicationAdapter<Madrasah> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Madrasah>;
}

extension MadrasahRelationshipGraphNodeX on RelationshipGraphNode<Madrasah> {
  RelationshipGraphNode<MadrasahInfo> get madrasahInfos {
    final meta =
        $MadrasahLocalAdapter._kMadrasahRelationshipMetas['madrasah-infos']
            as RelationshipMeta<MadrasahInfo>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<MadrasahPhoto> get madrasahPhotos {
    final meta =
        $MadrasahLocalAdapter._kMadrasahRelationshipMetas['madrasah-photos']
            as RelationshipMeta<MadrasahPhoto>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Madrasah _$MadrasahFromJson(Map<String, dynamic> json) => Madrasah(
      id: json['id'] as String?,
      title: json['title'] as String,
      introduction: json['introduction'] as String,
      excerpt: json['excerpt'] as String?,
      document: json['document'] as Map<dynamic, dynamic>?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      madrasahInfos: json['madrasah-infos'] == null
          ? null
          : HasMany<MadrasahInfo>.fromJson(
              json['madrasah-infos'] as Map<String, dynamic>),
      madrasahPhotos: json['madrasah-photos'] == null
          ? null
          : HasMany<MadrasahPhoto>.fromJson(
              json['madrasah-photos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MadrasahToJson(Madrasah instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'introduction': instance.introduction,
      'excerpt': instance.excerpt,
      'document': instance.document,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'madrasah-infos': instance.madrasahInfos,
      'madrasah-photos': instance.madrasahPhotos,
    };

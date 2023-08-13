// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'madrasah_info.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MadrasahInfoLocalAdapter on LocalAdapter<MadrasahInfo> {
  static final Map<String, RelationshipMeta> _kMadrasahInfoRelationshipMetas = {
    'madrasah': RelationshipMeta<Madrasah>(
      name: 'madrasah',
      inverseName: 'madrasahInfos',
      type: 'madrasahs',
      kind: 'BelongsTo',
      instance: (_) => (_ as MadrasahInfo).madrasah,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMadrasahInfoRelationshipMetas;

  @override
  MadrasahInfo deserialize(map) {
    map = transformDeserialize(map);
    return _$MadrasahInfoFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MadrasahInfoToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _madrasahInfosFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MadrasahInfoHiveLocalAdapter = HiveLocalAdapter<MadrasahInfo>
    with $MadrasahInfoLocalAdapter;

class $MadrasahInfoRemoteAdapter = RemoteAdapter<MadrasahInfo>
    with JSONAPIAdapter<MadrasahInfo>, ApplicationAdapter<MadrasahInfo>;

final internalMadrasahInfosRemoteAdapterProvider =
    Provider<RemoteAdapter<MadrasahInfo>>((ref) => $MadrasahInfoRemoteAdapter(
        $MadrasahInfoHiveLocalAdapter(ref),
        InternalHolder(_madrasahInfosFinders)));

final madrasahInfosRepositoryProvider =
    Provider<Repository<MadrasahInfo>>((ref) => Repository<MadrasahInfo>(ref));

extension MadrasahInfoDataRepositoryX on Repository<MadrasahInfo> {
  JSONAPIAdapter<MadrasahInfo> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MadrasahInfo>;
  ApplicationAdapter<MadrasahInfo> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MadrasahInfo>;
}

extension MadrasahInfoRelationshipGraphNodeX
    on RelationshipGraphNode<MadrasahInfo> {
  RelationshipGraphNode<Madrasah> get madrasah {
    final meta =
        $MadrasahInfoLocalAdapter._kMadrasahInfoRelationshipMetas['madrasah']
            as RelationshipMeta<Madrasah>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MadrasahInfo _$MadrasahInfoFromJson(Map<String, dynamic> json) => MadrasahInfo(
      id: json['id'] as String?,
      label: json['label'] as String,
      info: json['info'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      madrasah: json['madrasah'] == null
          ? null
          : BelongsTo<Madrasah>.fromJson(
              json['madrasah'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MadrasahInfoToJson(MadrasahInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'info': instance.info,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'madrasah': instance.madrasah,
    };

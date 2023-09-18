// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namaz_time.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $NamazTimeLocalAdapter on LocalAdapter<NamazTime> {
  static final Map<String, RelationshipMeta> _kNamazTimeRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kNamazTimeRelationshipMetas;

  @override
  NamazTime deserialize(map) {
    map = transformDeserialize(map);
    return _$NamazTimeFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$NamazTimeToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _namazTimesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $NamazTimeHiveLocalAdapter = HiveLocalAdapter<NamazTime>
    with $NamazTimeLocalAdapter;

class $NamazTimeRemoteAdapter = RemoteAdapter<NamazTime>
    with
        JSONAPIAdapter<NamazTime>,
        LocalResourceAdapter<NamazTime>,
        ApplicationAdapter<NamazTime>;

final internalNamazTimesRemoteAdapterProvider =
    Provider<RemoteAdapter<NamazTime>>((ref) => $NamazTimeRemoteAdapter(
        $NamazTimeHiveLocalAdapter(ref), InternalHolder(_namazTimesFinders)));

final namazTimesRepositoryProvider =
    Provider<Repository<NamazTime>>((ref) => Repository<NamazTime>(ref));

extension NamazTimeDataRepositoryX on Repository<NamazTime> {
  JSONAPIAdapter<NamazTime> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<NamazTime>;
  LocalResourceAdapter<NamazTime> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<NamazTime>;
  ApplicationAdapter<NamazTime> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<NamazTime>;
}

extension NamazTimeRelationshipGraphNodeX on RelationshipGraphNode<NamazTime> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NamazTime _$NamazTimeFromJson(Map<String, dynamic> json) => NamazTime(
      id: json['id'] as String?,
      title: json['title'] as String,
      titleBn: json['title-bn'] as String?,
      slug: json['slug'] as String,
      masail: json['masail'] as String,
      fazail: json['fazail'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$NamazTimeToJson(NamazTime instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title-bn': instance.titleBn,
      'slug': instance.slug,
      'masail': instance.masail,
      'fazail': instance.fazail,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $SpeakerLocalAdapter on LocalAdapter<Speaker> {
  static final Map<String, RelationshipMeta> _kSpeakerRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kSpeakerRelationshipMetas;

  @override
  Speaker deserialize(map) {
    map = transformDeserialize(map);
    return _$SpeakerFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$SpeakerToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _speakersFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $SpeakerHiveLocalAdapter = HiveLocalAdapter<Speaker>
    with $SpeakerLocalAdapter;

class $SpeakerRemoteAdapter = RemoteAdapter<Speaker>
    with JSONAPIAdapter<Speaker>, ApplicationAdapter<Speaker>;

final internalSpeakersRemoteAdapterProvider = Provider<RemoteAdapter<Speaker>>(
    (ref) => $SpeakerRemoteAdapter(
        $SpeakerHiveLocalAdapter(ref), InternalHolder(_speakersFinders)));

final speakersRepositoryProvider =
    Provider<Repository<Speaker>>((ref) => Repository<Speaker>(ref));

extension SpeakerDataRepositoryX on Repository<Speaker> {
  JSONAPIAdapter<Speaker> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Speaker>;
  ApplicationAdapter<Speaker> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Speaker>;
}

extension SpeakerRelationshipGraphNodeX on RelationshipGraphNode<Speaker> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Speaker _$SpeakerFromJson(Map<String, dynamic> json) => Speaker(
      id: json['id'] as String?,
      name: json['name'] as String,
      info: json['info'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$SpeakerToJson(Speaker instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

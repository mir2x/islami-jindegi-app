// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'malfuzat.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MalfuzatLocalAdapter on LocalAdapter<Malfuzat> {
  static final Map<String, RelationshipMeta> _kMalfuzatRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMalfuzatRelationshipMetas;

  @override
  Malfuzat deserialize(map) {
    map = transformDeserialize(map);
    return _$MalfuzatFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MalfuzatToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _malfuzatsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MalfuzatHiveLocalAdapter = HiveLocalAdapter<Malfuzat>
    with $MalfuzatLocalAdapter;

class $MalfuzatRemoteAdapter = RemoteAdapter<Malfuzat>
    with JSONAPIAdapter<Malfuzat>, ApplicationAdapter<Malfuzat>;

final internalMalfuzatsRemoteAdapterProvider =
    Provider<RemoteAdapter<Malfuzat>>(
  (ref) => $MalfuzatRemoteAdapter(
    $MalfuzatHiveLocalAdapter(ref.read, typeId: null),
    InternalHolder(_malfuzatsFinders),
  ),
);

final malfuzatsRepositoryProvider =
    Provider<Repository<Malfuzat>>((ref) => Repository<Malfuzat>(ref.read));

extension MalfuzatDataRepositoryX on Repository<Malfuzat> {
  JSONAPIAdapter<Malfuzat> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Malfuzat>;
  ApplicationAdapter<Malfuzat> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Malfuzat>;
}

extension MalfuzatRelationshipGraphNodeX on RelationshipGraphNode<Malfuzat> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Malfuzat _$MalfuzatFromJson(Map<String, dynamic> json) => Malfuzat(
      id: json['id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String?,
      excerpt: json['excerpt'] as String?,
      language: json['language'] as String,
      hasAudio: json['has-audio'] as bool?,
      position: json['position'] as int?,
      publishedAt: json['published-at'] as String?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$MalfuzatToJson(Malfuzat instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'excerpt': instance.excerpt,
      'language': instance.language,
      'has-audio': instance.hasAudio,
      'position': instance.position,
      'published-at': instance.publishedAt,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

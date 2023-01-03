// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'madrasah.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MadrasahLocalAdapter on LocalAdapter<Madrasah> {
  static final Map<String, RelationshipMeta> _kMadrasahRelationshipMetas = {};

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
    with JSONAPIAdapter<Madrasah>, ApplicationAdapter<Madrasah>;

final internalMadrasahsRemoteAdapterProvider =
    Provider<RemoteAdapter<Madrasah>>(
  (ref) => $MadrasahRemoteAdapter(
    $MadrasahHiveLocalAdapter(ref),
    InternalHolder(_madrasahsFinders),
  ),
);

final madrasahsRepositoryProvider =
    Provider<Repository<Madrasah>>((ref) => Repository<Madrasah>(ref));

extension MadrasahDataRepositoryX on Repository<Madrasah> {
  JSONAPIAdapter<Madrasah> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Madrasah>;
  ApplicationAdapter<Madrasah> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Madrasah>;
}

extension MadrasahRelationshipGraphNodeX on RelationshipGraphNode<Madrasah> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Madrasah _$MadrasahFromJson(Map<String, dynamic> json) => Madrasah(
      id: json['id'] as String?,
      title: json['title'] as String,
      introduction: json['introduction'] as String,
      excerpt: json['excerpt'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$MadrasahToJson(Madrasah instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'introduction': instance.introduction,
      'excerpt': instance.excerpt,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

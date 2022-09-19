// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bayan.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $BayanLocalAdapter on LocalAdapter<Bayan> {
  static final Map<String, RelationshipMeta> _kBayanRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kBayanRelationshipMetas;

  @override
  Bayan deserialize(map) {
    map = transformDeserialize(map);
    return _$BayanFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$BayanToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _bayansFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $BayanHiveLocalAdapter = HiveLocalAdapter<Bayan> with $BayanLocalAdapter;

class $BayanRemoteAdapter = RemoteAdapter<Bayan>
    with JSONAPIAdapter<Bayan>, ApplicationAdapter<Bayan>;

final internalBayansRemoteAdapterProvider = Provider<RemoteAdapter<Bayan>>(
    (ref) => $BayanRemoteAdapter($BayanHiveLocalAdapter(ref.read, typeId: null),
        InternalHolder(_bayansFinders)));

final bayansRepositoryProvider =
    Provider<Repository<Bayan>>((ref) => Repository<Bayan>(ref.read));

extension BayanDataRepositoryX on Repository<Bayan> {
  JSONAPIAdapter<Bayan> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Bayan>;
  ApplicationAdapter<Bayan> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Bayan>;
}

extension BayanRelationshipGraphNodeX on RelationshipGraphNode<Bayan> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bayan _$BayanFromJson(Map<String, dynamic> json) => Bayan(
      id: json['id'] as String?,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String?,
      language: json['language'] as String,
      location: json['location'] as String?,
      publishedAt: json['published-at'] as String,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$BayanToJson(Bayan instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'language': instance.language,
      'location': instance.location,
      'published-at': instance.publishedAt,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qari.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $QariLocalAdapter on LocalAdapter<Qari> {
  static final Map<String, RelationshipMeta> _kQariRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kQariRelationshipMetas;

  @override
  Qari deserialize(map) {
    map = transformDeserialize(map);
    return _$QariFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$QariToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _qarisFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $QariHiveLocalAdapter = HiveLocalAdapter<Qari> with $QariLocalAdapter;

class $QariRemoteAdapter = RemoteAdapter<Qari>
    with
        JSONAPIAdapter<Qari>,
        LocalResourceAdapter<Qari>,
        ApplicationAdapter<Qari>;

final internalQarisRemoteAdapterProvider = Provider<RemoteAdapter<Qari>>(
    (ref) => $QariRemoteAdapter(
        $QariHiveLocalAdapter(ref), InternalHolder(_qarisFinders)));

final qarisRepositoryProvider =
    Provider<Repository<Qari>>((ref) => Repository<Qari>(ref));

extension QariDataRepositoryX on Repository<Qari> {
  JSONAPIAdapter<Qari> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Qari>;
  LocalResourceAdapter<Qari> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<Qari>;
  ApplicationAdapter<Qari> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Qari>;
}

extension QariRelationshipGraphNodeX on RelationshipGraphNode<Qari> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Qari _$QariFromJson(Map<String, dynamic> json) => Qari(
      id: json['id'] as String?,
      name: json['name'] as String,
      nameBn: json['name-bn'] as String?,
      slug: json['slug'] as String,
      position: (json['position'] as num?)?.toInt(),
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$QariToJson(Qari instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name-bn': instance.nameBn,
      'slug': instance.slug,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

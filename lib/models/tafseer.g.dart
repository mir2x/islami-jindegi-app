// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafseer.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $TafseerLocalAdapter on LocalAdapter<Tafseer> {
  static final Map<String, RelationshipMeta> _kTafseerRelationshipMetas = {
    'tafseer-qitab': RelationshipMeta<TafseerQitab>(
      name: 'tafseerQitab',
      type: 'tafseerQitabs',
      kind: 'BelongsTo',
      instance: (_) => (_ as Tafseer).tafseerQitab,
    ),
    'ayah': RelationshipMeta<Ayah>(
      name: 'ayah',
      inverseName: 'tafseers',
      type: 'ayahs',
      kind: 'BelongsTo',
      instance: (_) => (_ as Tafseer).ayah,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kTafseerRelationshipMetas;

  @override
  Tafseer deserialize(map) {
    map = transformDeserialize(map);
    return _$TafseerFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$TafseerToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _tafseersFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $TafseerHiveLocalAdapter = HiveLocalAdapter<Tafseer>
    with $TafseerLocalAdapter;

class $TafseerRemoteAdapter = RemoteAdapter<Tafseer>
    with JSONAPIAdapter<Tafseer>, ApplicationAdapter<Tafseer>;

final internalTafseersRemoteAdapterProvider = Provider<RemoteAdapter<Tafseer>>(
    (ref) => $TafseerRemoteAdapter(
        $TafseerHiveLocalAdapter(ref), InternalHolder(_tafseersFinders)));

final tafseersRepositoryProvider =
    Provider<Repository<Tafseer>>((ref) => Repository<Tafseer>(ref));

extension TafseerDataRepositoryX on Repository<Tafseer> {
  JSONAPIAdapter<Tafseer> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Tafseer>;
  ApplicationAdapter<Tafseer> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Tafseer>;
}

extension TafseerRelationshipGraphNodeX on RelationshipGraphNode<Tafseer> {
  RelationshipGraphNode<TafseerQitab> get tafseerQitab {
    final meta =
        $TafseerLocalAdapter._kTafseerRelationshipMetas['tafseer-qitab']
            as RelationshipMeta<TafseerQitab>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<Ayah> get ayah {
    final meta = $TafseerLocalAdapter._kTafseerRelationshipMetas['ayah']
        as RelationshipMeta<Ayah>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tafseer _$TafseerFromJson(Map<String, dynamic> json) => Tafseer(
      id: json['id'] as String?,
      body: json['body'] as String,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      tafseerQitab: json['tafseer-qitab'] == null
          ? null
          : BelongsTo<TafseerQitab>.fromJson(
              json['tafseer-qitab'] as Map<String, dynamic>),
      ayah: json['ayah'] == null
          ? null
          : BelongsTo<Ayah>.fromJson(json['ayah'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TafseerToJson(Tafseer instance) => <String, dynamic>{
      'id': instance.id,
      'body': instance.body,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'tafseer-qitab': instance.tafseerQitab,
      'ayah': instance.ayah,
    };

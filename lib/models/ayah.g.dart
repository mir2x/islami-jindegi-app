// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $AyahLocalAdapter on LocalAdapter<Ayah> {
  static final Map<String, RelationshipMeta> _kAyahRelationshipMetas = {
    'surah': RelationshipMeta<Surah>(
      name: 'surah',
      inverseName: 'ayahs',
      type: 'surahs',
      kind: 'BelongsTo',
      instance: (_) => (_ as Ayah).surah,
    ),
    'para': RelationshipMeta<Para>(
      name: 'para',
      type: 'paras',
      kind: 'BelongsTo',
      instance: (_) => (_ as Ayah).para,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kAyahRelationshipMetas;

  @override
  Ayah deserialize(map) {
    map = transformDeserialize(map);
    return _$AyahFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$AyahToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _ayahsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $AyahHiveLocalAdapter = HiveLocalAdapter<Ayah> with $AyahLocalAdapter;

class $AyahRemoteAdapter = RemoteAdapter<Ayah>
    with JSONAPIAdapter<Ayah>, ApplicationAdapter<Ayah>;

final internalAyahsRemoteAdapterProvider = Provider<RemoteAdapter<Ayah>>(
  (ref) => $AyahRemoteAdapter(
    $AyahHiveLocalAdapter(ref.read, typeId: null),
    InternalHolder(_ayahsFinders),
  ),
);

final ayahsRepositoryProvider =
    Provider<Repository<Ayah>>((ref) => Repository<Ayah>(ref.read));

extension AyahDataRepositoryX on Repository<Ayah> {
  JSONAPIAdapter<Ayah> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Ayah>;
  ApplicationAdapter<Ayah> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Ayah>;
}

extension AyahRelationshipGraphNodeX on RelationshipGraphNode<Ayah> {
  RelationshipGraphNode<Surah> get surah {
    final meta = $AyahLocalAdapter._kAyahRelationshipMetas['surah']
        as RelationshipMeta<Surah>;
    return meta.clone(
      parent: this is RelationshipMeta ? this as RelationshipMeta : null,
    );
  }

  RelationshipGraphNode<Para> get para {
    final meta = $AyahLocalAdapter._kAyahRelationshipMetas['para']
        as RelationshipMeta<Para>;
    return meta.clone(
      parent: this is RelationshipMeta ? this as RelationshipMeta : null,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ayah _$AyahFromJson(Map<String, dynamic> json) => Ayah(
      id: json['id'] as String?,
      title: json['title'] as String,
      surahPosition: json['surah-position'] as int?,
      paraPosition: json['para-position'] as int?,
      ruku: json['ruku'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      surah: json['surah'] == null
          ? null
          : BelongsTo<Surah>.fromJson(json['surah'] as Map<String, dynamic>),
      para: json['para'] == null
          ? null
          : BelongsTo<Para>.fromJson(json['para'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AyahToJson(Ayah instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'surah-position': instance.surahPosition,
      'para-position': instance.paraPosition,
      'ruku': instance.ruku,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'surah': instance.surah,
      'para': instance.para,
    };

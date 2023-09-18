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
    ),
    'ayah-translations': RelationshipMeta<AyahTranslation>(
      name: 'ayahTranslations',
      inverseName: 'ayah',
      type: 'ayahTranslations',
      kind: 'HasMany',
      instance: (_) => (_ as Ayah).ayahTranslations,
    ),
    'tafseers': RelationshipMeta<Tafseer>(
      name: 'tafseers',
      inverseName: 'ayah',
      type: 'tafseers',
      kind: 'HasMany',
      instance: (_) => (_ as Ayah).tafseers,
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
    with
        JSONAPIAdapter<Ayah>,
        LocalResourceAdapter<Ayah>,
        ApplicationAdapter<Ayah>;

final internalAyahsRemoteAdapterProvider = Provider<RemoteAdapter<Ayah>>(
    (ref) => $AyahRemoteAdapter(
        $AyahHiveLocalAdapter(ref), InternalHolder(_ayahsFinders)));

final ayahsRepositoryProvider =
    Provider<Repository<Ayah>>((ref) => Repository<Ayah>(ref));

extension AyahDataRepositoryX on Repository<Ayah> {
  JSONAPIAdapter<Ayah> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Ayah>;
  LocalResourceAdapter<Ayah> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<Ayah>;
  ApplicationAdapter<Ayah> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Ayah>;
}

extension AyahRelationshipGraphNodeX on RelationshipGraphNode<Ayah> {
  RelationshipGraphNode<Surah> get surah {
    final meta = $AyahLocalAdapter._kAyahRelationshipMetas['surah']
        as RelationshipMeta<Surah>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<Para> get para {
    final meta = $AyahLocalAdapter._kAyahRelationshipMetas['para']
        as RelationshipMeta<Para>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<AyahTranslation> get ayahTranslations {
    final meta = $AyahLocalAdapter._kAyahRelationshipMetas['ayah-translations']
        as RelationshipMeta<AyahTranslation>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<Tafseer> get tafseers {
    final meta = $AyahLocalAdapter._kAyahRelationshipMetas['tafseers']
        as RelationshipMeta<Tafseer>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
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
      ayahTranslations: json['ayah-translations'] == null
          ? null
          : HasMany<AyahTranslation>.fromJson(
              json['ayah-translations'] as Map<String, dynamic>),
      tafseers: json['tafseers'] == null
          ? null
          : HasMany<Tafseer>.fromJson(json['tafseers'] as Map<String, dynamic>),
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
      'ayah-translations': instance.ayahTranslations,
      'tafseers': instance.tafseers,
    };

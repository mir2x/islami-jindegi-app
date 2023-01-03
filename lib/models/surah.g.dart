// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $SurahLocalAdapter on LocalAdapter<Surah> {
  static final Map<String, RelationshipMeta> _kSurahRelationshipMetas = {
    'ayahs': RelationshipMeta<Ayah>(
      name: 'ayahs',
      inverseName: 'surah',
      type: 'ayahs',
      kind: 'HasMany',
      instance: (_) => (_ as Surah).ayahs,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kSurahRelationshipMetas;

  @override
  Surah deserialize(map) {
    map = transformDeserialize(map);
    return _$SurahFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$SurahToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _surahsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $SurahHiveLocalAdapter = HiveLocalAdapter<Surah> with $SurahLocalAdapter;

class $SurahRemoteAdapter = RemoteAdapter<Surah>
    with JSONAPIAdapter<Surah>, ApplicationAdapter<Surah>;

final internalSurahsRemoteAdapterProvider = Provider<RemoteAdapter<Surah>>(
  (ref) => $SurahRemoteAdapter(
    $SurahHiveLocalAdapter(ref),
    InternalHolder(_surahsFinders),
  ),
);

final surahsRepositoryProvider =
    Provider<Repository<Surah>>((ref) => Repository<Surah>(ref));

extension SurahDataRepositoryX on Repository<Surah> {
  JSONAPIAdapter<Surah> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Surah>;
  ApplicationAdapter<Surah> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Surah>;
}

extension SurahRelationshipGraphNodeX on RelationshipGraphNode<Surah> {
  RelationshipGraphNode<Ayah> get ayahs {
    final meta = $SurahLocalAdapter._kSurahRelationshipMetas['ayahs']
        as RelationshipMeta<Ayah>;
    return meta.clone(
      parent: this is RelationshipMeta ? this as RelationshipMeta : null,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Surah _$SurahFromJson(Map<String, dynamic> json) => Surah(
      id: json['id'] as String?,
      title: json['title'] as String,
      titleBn: json['title-bn'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String?,
      totalAyat: json['total-ayat'] as int,
      totalRuku: json['total-ruku'] as int,
      introduction: json['introduction'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      ayahs: json['ayahs'] == null
          ? null
          : HasMany<Ayah>.fromJson(json['ayahs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SurahToJson(Surah instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title-bn': instance.titleBn,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'total-ayat': instance.totalAyat,
      'total-ruku': instance.totalRuku,
      'introduction': instance.introduction,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'ayahs': instance.ayahs,
    };

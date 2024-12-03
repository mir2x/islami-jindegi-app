// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_book_surah.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $QuranBookSurahLocalAdapter on LocalAdapter<QuranBookSurah> {
  static final Map<String, RelationshipMeta> _kQuranBookSurahRelationshipMetas =
      {
    'quran-book-page': RelationshipMeta<QuranBookPage>(
      name: 'quranBookPage',
      type: 'quranBookPages',
      kind: 'BelongsTo',
      instance: (_) => (_ as QuranBookSurah).quranBookPage,
    ),
    'surah': RelationshipMeta<Surah>(
      name: 'surah',
      type: 'surahs',
      kind: 'BelongsTo',
      instance: (_) => (_ as QuranBookSurah).surah,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kQuranBookSurahRelationshipMetas;

  @override
  QuranBookSurah deserialize(map) {
    map = transformDeserialize(map);
    return _$QuranBookSurahFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$QuranBookSurahToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _quranBookSurahsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $QuranBookSurahHiveLocalAdapter = HiveLocalAdapter<QuranBookSurah>
    with $QuranBookSurahLocalAdapter;

class $QuranBookSurahRemoteAdapter = RemoteAdapter<QuranBookSurah>
    with
        JSONAPIAdapter<QuranBookSurah>,
        LocalResourceAdapter<QuranBookSurah>,
        ApplicationAdapter<QuranBookSurah>;

final internalQuranBookSurahsRemoteAdapterProvider =
    Provider<RemoteAdapter<QuranBookSurah>>((ref) =>
        $QuranBookSurahRemoteAdapter($QuranBookSurahHiveLocalAdapter(ref),
            InternalHolder(_quranBookSurahsFinders)));

final quranBookSurahsRepositoryProvider = Provider<Repository<QuranBookSurah>>(
    (ref) => Repository<QuranBookSurah>(ref));

extension QuranBookSurahDataRepositoryX on Repository<QuranBookSurah> {
  JSONAPIAdapter<QuranBookSurah> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<QuranBookSurah>;
  LocalResourceAdapter<QuranBookSurah> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<QuranBookSurah>;
  ApplicationAdapter<QuranBookSurah> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<QuranBookSurah>;
}

extension QuranBookSurahRelationshipGraphNodeX
    on RelationshipGraphNode<QuranBookSurah> {
  RelationshipGraphNode<QuranBookPage> get quranBookPage {
    final meta = $QuranBookSurahLocalAdapter
            ._kQuranBookSurahRelationshipMetas['quran-book-page']
        as RelationshipMeta<QuranBookPage>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<Surah> get surah {
    final meta = $QuranBookSurahLocalAdapter
        ._kQuranBookSurahRelationshipMetas['surah'] as RelationshipMeta<Surah>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuranBookSurah _$QuranBookSurahFromJson(Map<String, dynamic> json) =>
    QuranBookSurah(
      id: json['id'] as String?,
      startAyah: (json['start-ayah'] as num).toInt(),
      endAyah: (json['end-ayah'] as num).toInt(),
      position: (json['position'] as num?)?.toInt(),
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      quranBookPage: json['quran-book-page'] == null
          ? null
          : BelongsTo<QuranBookPage>.fromJson(
              json['quran-book-page'] as Map<String, dynamic>),
      surah: json['surah'] == null
          ? null
          : BelongsTo<Surah>.fromJson(json['surah'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuranBookSurahToJson(QuranBookSurah instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start-ayah': instance.startAyah,
      'end-ayah': instance.endAyah,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'quran-book-page': instance.quranBookPage,
      'surah': instance.surah,
    };

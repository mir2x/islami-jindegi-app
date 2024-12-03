// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_book_qitab.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $QuranBookQitabLocalAdapter on LocalAdapter<QuranBookQitab> {
  static final Map<String, RelationshipMeta> _kQuranBookQitabRelationshipMetas =
      {
    'quran-book': RelationshipMeta<QuranBook>(
      name: 'quranBook',
      type: 'quranBooks',
      kind: 'BelongsTo',
      instance: (_) => (_ as QuranBookQitab).quranBook,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kQuranBookQitabRelationshipMetas;

  @override
  QuranBookQitab deserialize(map) {
    map = transformDeserialize(map);
    return _$QuranBookQitabFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$QuranBookQitabToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _quranBookQitabsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $QuranBookQitabHiveLocalAdapter = HiveLocalAdapter<QuranBookQitab>
    with $QuranBookQitabLocalAdapter;

class $QuranBookQitabRemoteAdapter = RemoteAdapter<QuranBookQitab>
    with
        JSONAPIAdapter<QuranBookQitab>,
        LocalResourceAdapter<QuranBookQitab>,
        ApplicationAdapter<QuranBookQitab>;

final internalQuranBookQitabsRemoteAdapterProvider =
    Provider<RemoteAdapter<QuranBookQitab>>((ref) =>
        $QuranBookQitabRemoteAdapter($QuranBookQitabHiveLocalAdapter(ref),
            InternalHolder(_quranBookQitabsFinders)));

final quranBookQitabsRepositoryProvider = Provider<Repository<QuranBookQitab>>(
    (ref) => Repository<QuranBookQitab>(ref));

extension QuranBookQitabDataRepositoryX on Repository<QuranBookQitab> {
  JSONAPIAdapter<QuranBookQitab> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<QuranBookQitab>;
  LocalResourceAdapter<QuranBookQitab> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<QuranBookQitab>;
  ApplicationAdapter<QuranBookQitab> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<QuranBookQitab>;
}

extension QuranBookQitabRelationshipGraphNodeX
    on RelationshipGraphNode<QuranBookQitab> {
  RelationshipGraphNode<QuranBook> get quranBook {
    final meta = $QuranBookQitabLocalAdapter
            ._kQuranBookQitabRelationshipMetas['quran-book']
        as RelationshipMeta<QuranBook>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuranBookQitab _$QuranBookQitabFromJson(Map<String, dynamic> json) =>
    QuranBookQitab(
      id: json['id'] as String?,
      title: json['title'] as String,
      titleBn: json['title-bn'] as String?,
      image: json['image'] as Map<dynamic, dynamic>?,
      document: json['document'] as Map<dynamic, dynamic>?,
      published: json['published'] as bool,
      position: (json['position'] as num?)?.toInt(),
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      quranBook: json['quran-book'] == null
          ? null
          : BelongsTo<QuranBook>.fromJson(
              json['quran-book'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuranBookQitabToJson(QuranBookQitab instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title-bn': instance.titleBn,
      'image': instance.image,
      'document': instance.document,
      'published': instance.published,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'quran-book': instance.quranBook,
    };

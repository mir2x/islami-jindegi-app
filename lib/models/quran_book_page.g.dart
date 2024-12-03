// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_book_page.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $QuranBookPageLocalAdapter on LocalAdapter<QuranBookPage> {
  static final Map<String, RelationshipMeta> _kQuranBookPageRelationshipMetas =
      {
    'quran-book': RelationshipMeta<QuranBook>(
      name: 'quranBook',
      type: 'quranBooks',
      kind: 'BelongsTo',
      instance: (_) => (_ as QuranBookPage).quranBook,
    ),
    'para': RelationshipMeta<Para>(
      name: 'para',
      type: 'paras',
      kind: 'BelongsTo',
      instance: (_) => (_ as QuranBookPage).para,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kQuranBookPageRelationshipMetas;

  @override
  QuranBookPage deserialize(map) {
    map = transformDeserialize(map);
    return _$QuranBookPageFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$QuranBookPageToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _quranBookPagesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $QuranBookPageHiveLocalAdapter = HiveLocalAdapter<QuranBookPage>
    with $QuranBookPageLocalAdapter;

class $QuranBookPageRemoteAdapter = RemoteAdapter<QuranBookPage>
    with
        JSONAPIAdapter<QuranBookPage>,
        LocalResourceAdapter<QuranBookPage>,
        ApplicationAdapter<QuranBookPage>;

final internalQuranBookPagesRemoteAdapterProvider =
    Provider<RemoteAdapter<QuranBookPage>>((ref) => $QuranBookPageRemoteAdapter(
        $QuranBookPageHiveLocalAdapter(ref),
        InternalHolder(_quranBookPagesFinders)));

final quranBookPagesRepositoryProvider = Provider<Repository<QuranBookPage>>(
    (ref) => Repository<QuranBookPage>(ref));

extension QuranBookPageDataRepositoryX on Repository<QuranBookPage> {
  JSONAPIAdapter<QuranBookPage> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<QuranBookPage>;
  LocalResourceAdapter<QuranBookPage> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<QuranBookPage>;
  ApplicationAdapter<QuranBookPage> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<QuranBookPage>;
}

extension QuranBookPageRelationshipGraphNodeX
    on RelationshipGraphNode<QuranBookPage> {
  RelationshipGraphNode<QuranBook> get quranBook {
    final meta = $QuranBookPageLocalAdapter
            ._kQuranBookPageRelationshipMetas['quran-book']
        as RelationshipMeta<QuranBook>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<Para> get para {
    final meta = $QuranBookPageLocalAdapter
        ._kQuranBookPageRelationshipMetas['para'] as RelationshipMeta<Para>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuranBookPage _$QuranBookPageFromJson(Map<String, dynamic> json) =>
    QuranBookPage(
      id: json['id'] as String?,
      title: json['title'] as String,
      paraPage: (json['para-page'] as num).toInt(),
      position: (json['position'] as num?)?.toInt(),
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      quranBook: json['quran-book'] == null
          ? null
          : BelongsTo<QuranBook>.fromJson(
              json['quran-book'] as Map<String, dynamic>),
      para: json['para'] == null
          ? null
          : BelongsTo<Para>.fromJson(json['para'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuranBookPageToJson(QuranBookPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'para-page': instance.paraPage,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'quran-book': instance.quranBook,
      'para': instance.para,
    };

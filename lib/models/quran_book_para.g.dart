// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_book_para.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $QuranBookParaLocalAdapter on LocalAdapter<QuranBookPara> {
  static final Map<String, RelationshipMeta> _kQuranBookParaRelationshipMetas =
      {
    'quran-book': RelationshipMeta<QuranBook>(
      name: 'quranBook',
      type: 'quranBooks',
      kind: 'BelongsTo',
      instance: (_) => (_ as QuranBookPara).quranBook,
    ),
    'para': RelationshipMeta<Para>(
      name: 'para',
      type: 'paras',
      kind: 'BelongsTo',
      instance: (_) => (_ as QuranBookPara).para,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kQuranBookParaRelationshipMetas;

  @override
  QuranBookPara deserialize(map) {
    map = transformDeserialize(map);
    return _$QuranBookParaFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$QuranBookParaToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _quranBookParasFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $QuranBookParaHiveLocalAdapter = HiveLocalAdapter<QuranBookPara>
    with $QuranBookParaLocalAdapter;

class $QuranBookParaRemoteAdapter = RemoteAdapter<QuranBookPara>
    with
        JSONAPIAdapter<QuranBookPara>,
        LocalResourceAdapter<QuranBookPara>,
        ApplicationAdapter<QuranBookPara>;

final internalQuranBookParasRemoteAdapterProvider =
    Provider<RemoteAdapter<QuranBookPara>>((ref) => $QuranBookParaRemoteAdapter(
        $QuranBookParaHiveLocalAdapter(ref),
        InternalHolder(_quranBookParasFinders)));

final quranBookParasRepositoryProvider = Provider<Repository<QuranBookPara>>(
    (ref) => Repository<QuranBookPara>(ref));

extension QuranBookParaDataRepositoryX on Repository<QuranBookPara> {
  JSONAPIAdapter<QuranBookPara> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<QuranBookPara>;
  LocalResourceAdapter<QuranBookPara> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<QuranBookPara>;
  ApplicationAdapter<QuranBookPara> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<QuranBookPara>;
}

extension QuranBookParaRelationshipGraphNodeX
    on RelationshipGraphNode<QuranBookPara> {
  RelationshipGraphNode<QuranBook> get quranBook {
    final meta = $QuranBookParaLocalAdapter
            ._kQuranBookParaRelationshipMetas['quran-book']
        as RelationshipMeta<QuranBook>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<Para> get para {
    final meta = $QuranBookParaLocalAdapter
        ._kQuranBookParaRelationshipMetas['para'] as RelationshipMeta<Para>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuranBookPara _$QuranBookParaFromJson(Map<String, dynamic> json) =>
    QuranBookPara(
      id: json['id'] as String?,
      totalPage: json['total-page'] as int,
      position: json['position'] as int?,
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

Map<String, dynamic> _$QuranBookParaToJson(QuranBookPara instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total-page': instance.totalPage,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'quran-book': instance.quranBook,
      'para': instance.para,
    };

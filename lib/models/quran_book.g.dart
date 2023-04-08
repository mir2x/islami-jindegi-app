// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_book.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $QuranBookLocalAdapter on LocalAdapter<QuranBook> {
  static final Map<String, RelationshipMeta> _kQuranBookRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kQuranBookRelationshipMetas;

  @override
  QuranBook deserialize(map) {
    map = transformDeserialize(map);
    return _$QuranBookFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$QuranBookToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _quranBooksFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $QuranBookHiveLocalAdapter = HiveLocalAdapter<QuranBook>
    with $QuranBookLocalAdapter;

class $QuranBookRemoteAdapter = RemoteAdapter<QuranBook>
    with JSONAPIAdapter<QuranBook>, ApplicationAdapter<QuranBook>;

final internalQuranBooksRemoteAdapterProvider =
    Provider<RemoteAdapter<QuranBook>>((ref) => $QuranBookRemoteAdapter(
        $QuranBookHiveLocalAdapter(ref), InternalHolder(_quranBooksFinders)));

final quranBooksRepositoryProvider =
    Provider<Repository<QuranBook>>((ref) => Repository<QuranBook>(ref));

extension QuranBookDataRepositoryX on Repository<QuranBook> {
  JSONAPIAdapter<QuranBook> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<QuranBook>;
  ApplicationAdapter<QuranBook> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<QuranBook>;
}

extension QuranBookRelationshipGraphNodeX on RelationshipGraphNode<QuranBook> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuranBook _$QuranBookFromJson(Map<String, dynamic> json) => QuranBook(
      id: json['id'] as String?,
      title: json['title'] as String,
      titleBn: json['title-bn'] as String?,
      image: json['image'] as Map<dynamic, dynamic>?,
      document: json['document'] as Map<dynamic, dynamic>?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$QuranBookToJson(QuranBook instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title-bn': instance.titleBn,
      'image': instance.image,
      'document': instance.document,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $ChapterLocalAdapter on LocalAdapter<Chapter> {
  static final Map<String, RelationshipMeta> _kChapterRelationshipMetas = {
    'book': RelationshipMeta<Book>(
      name: 'book',
      type: 'books',
      kind: 'BelongsTo',
      instance: (_) => (_ as Chapter).book,
    ),
    'subchapters': RelationshipMeta<Subchapter>(
      name: 'subchapters',
      inverseName: 'chapter',
      type: 'subchapters',
      kind: 'HasMany',
      instance: (_) => (_ as Chapter).subchapters,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kChapterRelationshipMetas;

  @override
  Chapter deserialize(map) {
    map = transformDeserialize(map);
    return _$ChapterFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$ChapterToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _chaptersFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $ChapterHiveLocalAdapter = HiveLocalAdapter<Chapter>
    with $ChapterLocalAdapter;

class $ChapterRemoteAdapter = RemoteAdapter<Chapter>
    with
        JSONAPIAdapter<Chapter>,
        LocalResourceAdapter<Chapter>,
        ApplicationAdapter<Chapter>;

final internalChaptersRemoteAdapterProvider = Provider<RemoteAdapter<Chapter>>(
    (ref) => $ChapterRemoteAdapter(
        $ChapterHiveLocalAdapter(ref), InternalHolder(_chaptersFinders)));

final chaptersRepositoryProvider =
    Provider<Repository<Chapter>>((ref) => Repository<Chapter>(ref));

extension ChapterDataRepositoryX on Repository<Chapter> {
  JSONAPIAdapter<Chapter> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Chapter>;
  LocalResourceAdapter<Chapter> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<Chapter>;
  ApplicationAdapter<Chapter> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Chapter>;
}

extension ChapterRelationshipGraphNodeX on RelationshipGraphNode<Chapter> {
  RelationshipGraphNode<Book> get book {
    final meta = $ChapterLocalAdapter._kChapterRelationshipMetas['book']
        as RelationshipMeta<Book>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }

  RelationshipGraphNode<Subchapter> get subchapters {
    final meta = $ChapterLocalAdapter._kChapterRelationshipMetas['subchapters']
        as RelationshipMeta<Subchapter>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
      id: json['id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      book: json['book'] == null
          ? null
          : BelongsTo<Book>.fromJson(json['book'] as Map<String, dynamic>),
      subchapters: json['subchapters'] == null
          ? null
          : HasMany<Subchapter>.fromJson(
              json['subchapters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'book': instance.book,
      'subchapters': instance.subchapters,
    };

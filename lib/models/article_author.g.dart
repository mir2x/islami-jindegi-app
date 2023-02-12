// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_author.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $ArticleAuthorLocalAdapter on LocalAdapter<ArticleAuthor> {
  static final Map<String, RelationshipMeta> _kArticleAuthorRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kArticleAuthorRelationshipMetas;

  @override
  ArticleAuthor deserialize(map) {
    map = transformDeserialize(map);
    return _$ArticleAuthorFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$ArticleAuthorToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _articleAuthorsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $ArticleAuthorHiveLocalAdapter = HiveLocalAdapter<ArticleAuthor>
    with $ArticleAuthorLocalAdapter;

class $ArticleAuthorRemoteAdapter = RemoteAdapter<ArticleAuthor>
    with JSONAPIAdapter<ArticleAuthor>, ApplicationAdapter<ArticleAuthor>;

final internalArticleAuthorsRemoteAdapterProvider =
    Provider<RemoteAdapter<ArticleAuthor>>((ref) => $ArticleAuthorRemoteAdapter(
        $ArticleAuthorHiveLocalAdapter(ref),
        InternalHolder(_articleAuthorsFinders)));

final articleAuthorsRepositoryProvider = Provider<Repository<ArticleAuthor>>(
    (ref) => Repository<ArticleAuthor>(ref));

extension ArticleAuthorDataRepositoryX on Repository<ArticleAuthor> {
  JSONAPIAdapter<ArticleAuthor> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<ArticleAuthor>;
  ApplicationAdapter<ArticleAuthor> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<ArticleAuthor>;
}

extension ArticleAuthorRelationshipGraphNodeX
    on RelationshipGraphNode<ArticleAuthor> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleAuthor _$ArticleAuthorFromJson(Map<String, dynamic> json) =>
    ArticleAuthor(
      id: json['id'] as String?,
      name: json['name'] as String,
      info: json['info'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$ArticleAuthorToJson(ArticleAuthor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

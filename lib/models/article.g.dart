// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $ArticleLocalAdapter on LocalAdapter<Article> {
  static final Map<String, RelationshipMeta> _kArticleRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kArticleRelationshipMetas;

  @override
  Article deserialize(map) {
    map = transformDeserialize(map);
    return _$ArticleFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$ArticleToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _articlesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $ArticleHiveLocalAdapter = HiveLocalAdapter<Article>
    with $ArticleLocalAdapter;

class $ArticleRemoteAdapter = RemoteAdapter<Article>
    with JSONAPIAdapter<Article>, ApplicationAdapter<Article>;

final internalArticlesRemoteAdapterProvider = Provider<RemoteAdapter<Article>>(
  (ref) => $ArticleRemoteAdapter(
    $ArticleHiveLocalAdapter(ref),
    InternalHolder(_articlesFinders),
  ),
);

final articlesRepositoryProvider =
    Provider<Repository<Article>>((ref) => Repository<Article>(ref));

extension ArticleDataRepositoryX on Repository<Article> {
  JSONAPIAdapter<Article> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Article>;
  ApplicationAdapter<Article> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Article>;
}

extension ArticleRelationshipGraphNodeX on RelationshipGraphNode<Article> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      body: json['body'] as String,
      excerpt: json['excerpt'] as String?,
      language: json['language'] as String,
      position: json['position'] as int?,
      publishedAt: json['published-at'] as String?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'body': instance.body,
      'excerpt': instance.excerpt,
      'language': instance.language,
      'position': instance.position,
      'published-at': instance.publishedAt,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_category.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $ArticleCategoryLocalAdapter on LocalAdapter<ArticleCategory> {
  static final Map<String, RelationshipMeta>
      _kArticleCategoryRelationshipMetas = {
    'article-subcategories': RelationshipMeta<ArticleSubcategory>(
      name: 'articleSubcategories',
      inverseName: 'articleCategory',
      type: 'articleSubcategories',
      kind: 'HasMany',
      instance: (_) => (_ as ArticleCategory).articleSubcategories,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kArticleCategoryRelationshipMetas;

  @override
  ArticleCategory deserialize(map) {
    map = transformDeserialize(map);
    return _$ArticleCategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$ArticleCategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _articleCategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $ArticleCategoryHiveLocalAdapter = HiveLocalAdapter<ArticleCategory>
    with $ArticleCategoryLocalAdapter;

class $ArticleCategoryRemoteAdapter = RemoteAdapter<ArticleCategory>
    with JSONAPIAdapter<ArticleCategory>, ApplicationAdapter<ArticleCategory>;

final internalArticleCategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<ArticleCategory>>((ref) =>
        $ArticleCategoryRemoteAdapter($ArticleCategoryHiveLocalAdapter(ref),
            InternalHolder(_articleCategoriesFinders)));

final articleCategoriesRepositoryProvider =
    Provider<Repository<ArticleCategory>>(
        (ref) => Repository<ArticleCategory>(ref));

extension ArticleCategoryDataRepositoryX on Repository<ArticleCategory> {
  JSONAPIAdapter<ArticleCategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<ArticleCategory>;
  ApplicationAdapter<ArticleCategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<ArticleCategory>;
}

extension ArticleCategoryRelationshipGraphNodeX
    on RelationshipGraphNode<ArticleCategory> {
  RelationshipGraphNode<ArticleSubcategory> get articleSubcategories {
    final meta = $ArticleCategoryLocalAdapter
            ._kArticleCategoryRelationshipMetas['article-subcategories']
        as RelationshipMeta<ArticleSubcategory>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleCategory _$ArticleCategoryFromJson(Map<String, dynamic> json) =>
    ArticleCategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      articleSubcategories: json['article-subcategories'] == null
          ? null
          : HasMany<ArticleSubcategory>.fromJson(
              json['article-subcategories'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArticleCategoryToJson(ArticleCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'article-subcategories': instance.articleSubcategories,
    };

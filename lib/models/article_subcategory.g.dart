// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_subcategory.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $ArticleSubcategoryLocalAdapter on LocalAdapter<ArticleSubcategory> {
  static final Map<String, RelationshipMeta>
      _kArticleSubcategoryRelationshipMetas = {
    'article-category': RelationshipMeta<ArticleCategory>(
      name: 'articleCategory',
      inverseName: 'articleSubcategories',
      type: 'articleCategories',
      kind: 'BelongsTo',
      instance: (_) => (_ as ArticleSubcategory).articleCategory,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kArticleSubcategoryRelationshipMetas;

  @override
  ArticleSubcategory deserialize(map) {
    map = transformDeserialize(map);
    return _$ArticleSubcategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$ArticleSubcategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _articleSubcategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $ArticleSubcategoryHiveLocalAdapter = HiveLocalAdapter<ArticleSubcategory>
    with $ArticleSubcategoryLocalAdapter;

class $ArticleSubcategoryRemoteAdapter = RemoteAdapter<ArticleSubcategory>
    with
        JSONAPIAdapter<ArticleSubcategory>,
        ApplicationAdapter<ArticleSubcategory>;

final internalArticleSubcategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<ArticleSubcategory>>((ref) =>
        $ArticleSubcategoryRemoteAdapter(
            $ArticleSubcategoryHiveLocalAdapter(ref),
            InternalHolder(_articleSubcategoriesFinders)));

final articleSubcategoriesRepositoryProvider =
    Provider<Repository<ArticleSubcategory>>(
        (ref) => Repository<ArticleSubcategory>(ref));

extension ArticleSubcategoryDataRepositoryX on Repository<ArticleSubcategory> {
  JSONAPIAdapter<ArticleSubcategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<ArticleSubcategory>;
  ApplicationAdapter<ArticleSubcategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<ArticleSubcategory>;
}

extension ArticleSubcategoryRelationshipGraphNodeX
    on RelationshipGraphNode<ArticleSubcategory> {
  RelationshipGraphNode<ArticleCategory> get articleCategory {
    final meta = $ArticleSubcategoryLocalAdapter
            ._kArticleSubcategoryRelationshipMetas['article-category']
        as RelationshipMeta<ArticleCategory>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleSubcategory _$ArticleSubcategoryFromJson(Map<String, dynamic> json) =>
    ArticleSubcategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      articleCategory: json['article-category'] == null
          ? null
          : BelongsTo<ArticleCategory>.fromJson(
              json['article-category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArticleSubcategoryToJson(ArticleSubcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'article-category': instance.articleCategory,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $NewsLocalAdapter on LocalAdapter<News> {
  static final Map<String, RelationshipMeta> _kNewsRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kNewsRelationshipMetas;

  @override
  News deserialize(map) {
    map = transformDeserialize(map);
    return _$NewsFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$NewsToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _newsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $NewsHiveLocalAdapter = HiveLocalAdapter<News> with $NewsLocalAdapter;

class $NewsRemoteAdapter = RemoteAdapter<News>
    with JSONAPIAdapter<News>, ApplicationAdapter<News>;

final internalNewsRemoteAdapterProvider = Provider<RemoteAdapter<News>>((ref) =>
    $NewsRemoteAdapter(
        $NewsHiveLocalAdapter(ref), InternalHolder(_newsFinders)));

final newsRepositoryProvider =
    Provider<Repository<News>>((ref) => Repository<News>(ref));

extension NewsDataRepositoryX on Repository<News> {
  JSONAPIAdapter<News> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<News>;
  ApplicationAdapter<News> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<News>;
}

extension NewsRelationshipGraphNodeX on RelationshipGraphNode<News> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      body: json['body'] as String,
      excerpt: json['excerpt'] as String?,
      language: json['language'] as String,
      published: json['published'] as bool?,
      publishedAt: json['published-at'] as String,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'body': instance.body,
      'excerpt': instance.excerpt,
      'language': instance.language,
      'published': instance.published,
      'published-at': instance.publishedAt,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

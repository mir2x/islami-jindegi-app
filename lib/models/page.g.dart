// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $PageLocalAdapter on LocalAdapter<Page> {
  static final Map<String, RelationshipMeta> _kPageRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kPageRelationshipMetas;

  @override
  Page deserialize(map) {
    map = transformDeserialize(map);
    return _$PageFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$PageToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _pagesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $PageHiveLocalAdapter = HiveLocalAdapter<Page> with $PageLocalAdapter;

class $PageRemoteAdapter = RemoteAdapter<Page>
    with
        JSONAPIAdapter<Page>,
        LocalDatabaseAdapter<Page>,
        ApplicationAdapter<Page>;

final internalPagesRemoteAdapterProvider = Provider<RemoteAdapter<Page>>(
    (ref) => $PageRemoteAdapter(
        $PageHiveLocalAdapter(ref), InternalHolder(_pagesFinders)));

final pagesRepositoryProvider =
    Provider<Repository<Page>>((ref) => Repository<Page>(ref));

extension PageDataRepositoryX on Repository<Page> {
  JSONAPIAdapter<Page> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Page>;
  LocalDatabaseAdapter<Page> get localDatabaseAdapter =>
      remoteAdapter as LocalDatabaseAdapter<Page>;
  ApplicationAdapter<Page> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Page>;
}

extension PageRelationshipGraphNodeX on RelationshipGraphNode<Page> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Page _$PageFromJson(Map<String, dynamic> json) => Page(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      body: json['body'] as String,
      image: json['image'] as Map<dynamic, dynamic>?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$PageToJson(Page instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'body': instance.body,
      'image': instance.image,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subchapter.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $SubchapterLocalAdapter on LocalAdapter<Subchapter> {
  static final Map<String, RelationshipMeta> _kSubchapterRelationshipMetas = {
    'chapter': RelationshipMeta<Chapter>(
      name: 'chapter',
      inverseName: 'subchapters',
      type: 'chapters',
      kind: 'BelongsTo',
      instance: (_) => (_ as Subchapter).chapter,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kSubchapterRelationshipMetas;

  @override
  Subchapter deserialize(map) {
    map = transformDeserialize(map);
    return _$SubchapterFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$SubchapterToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _subchaptersFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $SubchapterHiveLocalAdapter = HiveLocalAdapter<Subchapter>
    with $SubchapterLocalAdapter;

class $SubchapterRemoteAdapter = RemoteAdapter<Subchapter>
    with JSONAPIAdapter<Subchapter>, ApplicationAdapter<Subchapter>;

final internalSubchaptersRemoteAdapterProvider =
    Provider<RemoteAdapter<Subchapter>>(
  (ref) => $SubchapterRemoteAdapter(
    $SubchapterHiveLocalAdapter(ref.read, typeId: null),
    InternalHolder(_subchaptersFinders),
  ),
);

final subchaptersRepositoryProvider =
    Provider<Repository<Subchapter>>((ref) => Repository<Subchapter>(ref.read));

extension SubchapterDataRepositoryX on Repository<Subchapter> {
  JSONAPIAdapter<Subchapter> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Subchapter>;
  ApplicationAdapter<Subchapter> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Subchapter>;
}

extension SubchapterRelationshipGraphNodeX
    on RelationshipGraphNode<Subchapter> {
  RelationshipGraphNode<Chapter> get chapter {
    final meta = $SubchapterLocalAdapter
        ._kSubchapterRelationshipMetas['chapter'] as RelationshipMeta<Chapter>;
    return meta.clone(
      parent: this is RelationshipMeta ? this as RelationshipMeta : null,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subchapter _$SubchapterFromJson(Map<String, dynamic> json) => Subchapter(
      id: json['id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      chapter: json['chapter'] == null
          ? null
          : BelongsTo<Chapter>.fromJson(
              json['chapter'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SubchapterToJson(Subchapter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'chapter': instance.chapter,
    };

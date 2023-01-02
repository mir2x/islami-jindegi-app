// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $AuthorLocalAdapter on LocalAdapter<Author> {
  static final Map<String, RelationshipMeta> _kAuthorRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kAuthorRelationshipMetas;

  @override
  Author deserialize(map) {
    map = transformDeserialize(map);
    return _$AuthorFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$AuthorToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _authorsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $AuthorHiveLocalAdapter = HiveLocalAdapter<Author>
    with $AuthorLocalAdapter;

class $AuthorRemoteAdapter = RemoteAdapter<Author>
    with JSONAPIAdapter<Author>, ApplicationAdapter<Author>;

final internalAuthorsRemoteAdapterProvider = Provider<RemoteAdapter<Author>>(
    (ref) => $AuthorRemoteAdapter(
        $AuthorHiveLocalAdapter(ref.read, typeId: null),
        InternalHolder(_authorsFinders)));

final authorsRepositoryProvider =
    Provider<Repository<Author>>((ref) => Repository<Author>(ref.read));

extension AuthorDataRepositoryX on Repository<Author> {
  JSONAPIAdapter<Author> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Author>;
  ApplicationAdapter<Author> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Author>;
}

extension AuthorRelationshipGraphNodeX on RelationshipGraphNode<Author> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: json['id'] as String?,
      name: json['name'] as String,
      info: json['info'] as String?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

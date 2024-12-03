// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafseer_qitab.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $TafseerQitabLocalAdapter on LocalAdapter<TafseerQitab> {
  static final Map<String, RelationshipMeta> _kTafseerQitabRelationshipMetas =
      {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kTafseerQitabRelationshipMetas;

  @override
  TafseerQitab deserialize(map) {
    map = transformDeserialize(map);
    return _$TafseerQitabFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$TafseerQitabToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _tafseerQitabsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $TafseerQitabHiveLocalAdapter = HiveLocalAdapter<TafseerQitab>
    with $TafseerQitabLocalAdapter;

class $TafseerQitabRemoteAdapter = RemoteAdapter<TafseerQitab>
    with
        JSONAPIAdapter<TafseerQitab>,
        LocalResourceAdapter<TafseerQitab>,
        ApplicationAdapter<TafseerQitab>;

final internalTafseerQitabsRemoteAdapterProvider =
    Provider<RemoteAdapter<TafseerQitab>>((ref) => $TafseerQitabRemoteAdapter(
        $TafseerQitabHiveLocalAdapter(ref),
        InternalHolder(_tafseerQitabsFinders)));

final tafseerQitabsRepositoryProvider =
    Provider<Repository<TafseerQitab>>((ref) => Repository<TafseerQitab>(ref));

extension TafseerQitabDataRepositoryX on Repository<TafseerQitab> {
  JSONAPIAdapter<TafseerQitab> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<TafseerQitab>;
  LocalResourceAdapter<TafseerQitab> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<TafseerQitab>;
  ApplicationAdapter<TafseerQitab> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<TafseerQitab>;
}

extension TafseerQitabRelationshipGraphNodeX
    on RelationshipGraphNode<TafseerQitab> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TafseerQitab _$TafseerQitabFromJson(Map<String, dynamic> json) => TafseerQitab(
      id: json['id'] as String?,
      title: json['title'] as String,
      author: json['author'] as String,
      position: (json['position'] as num?)?.toInt(),
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$TafseerQitabToJson(TafseerQitab instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

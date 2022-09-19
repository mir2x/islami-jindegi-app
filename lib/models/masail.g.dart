// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masail.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MasailLocalAdapter on LocalAdapter<Masail> {
  static final Map<String, RelationshipMeta> _kMasailRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMasailRelationshipMetas;

  @override
  Masail deserialize(map) {
    map = transformDeserialize(map);
    return _$MasailFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MasailToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _masailsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MasailHiveLocalAdapter = HiveLocalAdapter<Masail>
    with $MasailLocalAdapter;

class $MasailRemoteAdapter = RemoteAdapter<Masail>
    with JSONAPIAdapter<Masail>, ApplicationAdapter<Masail>;

final internalMasailsRemoteAdapterProvider = Provider<RemoteAdapter<Masail>>(
    (ref) => $MasailRemoteAdapter(
        $MasailHiveLocalAdapter(ref.read, typeId: null),
        InternalHolder(_masailsFinders)));

final masailsRepositoryProvider =
    Provider<Repository<Masail>>((ref) => Repository<Masail>(ref.read));

extension MasailDataRepositoryX on Repository<Masail> {
  JSONAPIAdapter<Masail> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Masail>;
  ApplicationAdapter<Masail> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Masail>;
}

extension MasailRelationshipGraphNodeX on RelationshipGraphNode<Masail> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Masail _$MasailFromJson(Map<String, dynamic> json) => Masail(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      question: json['question'] as String,
      answer: json['answer'] as String,
      language: json['language'] as String,
      hasAudio: json['has-audio'] as bool?,
      position: json['position'] as int?,
      publishedAt: json['published-at'] as String?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$MasailToJson(Masail instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'question': instance.question,
      'answer': instance.answer,
      'language': instance.language,
      'has-audio': instance.hasAudio,
      'position': instance.position,
      'published-at': instance.publishedAt,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

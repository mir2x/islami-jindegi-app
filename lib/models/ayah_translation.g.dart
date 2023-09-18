// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_translation.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $AyahTranslationLocalAdapter on LocalAdapter<AyahTranslation> {
  static final Map<String, RelationshipMeta>
      _kAyahTranslationRelationshipMetas = {
    'ayah': RelationshipMeta<Ayah>(
      name: 'ayah',
      inverseName: 'ayahTranslations',
      type: 'ayahs',
      kind: 'BelongsTo',
      instance: (_) => (_ as AyahTranslation).ayah,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kAyahTranslationRelationshipMetas;

  @override
  AyahTranslation deserialize(map) {
    map = transformDeserialize(map);
    return _$AyahTranslationFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$AyahTranslationToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _ayahTranslationsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $AyahTranslationHiveLocalAdapter = HiveLocalAdapter<AyahTranslation>
    with $AyahTranslationLocalAdapter;

class $AyahTranslationRemoteAdapter = RemoteAdapter<AyahTranslation>
    with
        JSONAPIAdapter<AyahTranslation>,
        LocalResourceAdapter<AyahTranslation>,
        ApplicationAdapter<AyahTranslation>;

final internalAyahTranslationsRemoteAdapterProvider =
    Provider<RemoteAdapter<AyahTranslation>>((ref) =>
        $AyahTranslationRemoteAdapter($AyahTranslationHiveLocalAdapter(ref),
            InternalHolder(_ayahTranslationsFinders)));

final ayahTranslationsRepositoryProvider =
    Provider<Repository<AyahTranslation>>(
        (ref) => Repository<AyahTranslation>(ref));

extension AyahTranslationDataRepositoryX on Repository<AyahTranslation> {
  JSONAPIAdapter<AyahTranslation> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<AyahTranslation>;
  LocalResourceAdapter<AyahTranslation> get localResourceAdapter =>
      remoteAdapter as LocalResourceAdapter<AyahTranslation>;
  ApplicationAdapter<AyahTranslation> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<AyahTranslation>;
}

extension AyahTranslationRelationshipGraphNodeX
    on RelationshipGraphNode<AyahTranslation> {
  RelationshipGraphNode<Ayah> get ayah {
    final meta = $AyahTranslationLocalAdapter
        ._kAyahTranslationRelationshipMetas['ayah'] as RelationshipMeta<Ayah>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AyahTranslation _$AyahTranslationFromJson(Map<String, dynamic> json) =>
    AyahTranslation(
      id: json['id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      ayah: json['ayah'] == null
          ? null
          : BelongsTo<Ayah>.fromJson(json['ayah'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AyahTranslationToJson(AyahTranslation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'ayah': instance.ayah,
    };

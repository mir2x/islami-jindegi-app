// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'madrasah_photo.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MadrasahPhotoLocalAdapter on LocalAdapter<MadrasahPhoto> {
  static final Map<String, RelationshipMeta> _kMadrasahPhotoRelationshipMetas =
      {
    'madrasah': RelationshipMeta<Madrasah>(
      name: 'madrasah',
      inverseName: 'madrasahPhotos',
      type: 'madrasahs',
      kind: 'BelongsTo',
      instance: (_) => (_ as MadrasahPhoto).madrasah,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMadrasahPhotoRelationshipMetas;

  @override
  MadrasahPhoto deserialize(map) {
    map = transformDeserialize(map);
    return _$MadrasahPhotoFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MadrasahPhotoToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _madrasahPhotosFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MadrasahPhotoHiveLocalAdapter = HiveLocalAdapter<MadrasahPhoto>
    with $MadrasahPhotoLocalAdapter;

class $MadrasahPhotoRemoteAdapter = RemoteAdapter<MadrasahPhoto>
    with JSONAPIAdapter<MadrasahPhoto>, ApplicationAdapter<MadrasahPhoto>;

final internalMadrasahPhotosRemoteAdapterProvider =
    Provider<RemoteAdapter<MadrasahPhoto>>((ref) => $MadrasahPhotoRemoteAdapter(
        $MadrasahPhotoHiveLocalAdapter(ref),
        InternalHolder(_madrasahPhotosFinders)));

final madrasahPhotosRepositoryProvider = Provider<Repository<MadrasahPhoto>>(
    (ref) => Repository<MadrasahPhoto>(ref));

extension MadrasahPhotoDataRepositoryX on Repository<MadrasahPhoto> {
  JSONAPIAdapter<MadrasahPhoto> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MadrasahPhoto>;
  ApplicationAdapter<MadrasahPhoto> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MadrasahPhoto>;
}

extension MadrasahPhotoRelationshipGraphNodeX
    on RelationshipGraphNode<MadrasahPhoto> {
  RelationshipGraphNode<Madrasah> get madrasah {
    final meta =
        $MadrasahPhotoLocalAdapter._kMadrasahPhotoRelationshipMetas['madrasah']
            as RelationshipMeta<Madrasah>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MadrasahPhoto _$MadrasahPhotoFromJson(Map<String, dynamic> json) =>
    MadrasahPhoto(
      id: json['id'] as String?,
      title: json['title'] as String?,
      image: json['image'] as Map<dynamic, dynamic>?,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      madrasah: json['madrasah'] == null
          ? null
          : BelongsTo<Madrasah>.fromJson(
              json['madrasah'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MadrasahPhotoToJson(MadrasahPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'madrasah': instance.madrasah,
    };

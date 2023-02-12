// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masail_subcategory.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $MasailSubcategoryLocalAdapter on LocalAdapter<MasailSubcategory> {
  static final Map<String, RelationshipMeta>
      _kMasailSubcategoryRelationshipMetas = {
    'masail-category': RelationshipMeta<MasailCategory>(
      name: 'masailCategory',
      inverseName: 'masailSubcategories',
      type: 'masailCategories',
      kind: 'BelongsTo',
      instance: (_) => (_ as MasailSubcategory).masailCategory,
    )
  };

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kMasailSubcategoryRelationshipMetas;

  @override
  MasailSubcategory deserialize(map) {
    map = transformDeserialize(map);
    return _$MasailSubcategoryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$MasailSubcategoryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _masailSubcategoriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $MasailSubcategoryHiveLocalAdapter = HiveLocalAdapter<MasailSubcategory>
    with $MasailSubcategoryLocalAdapter;

class $MasailSubcategoryRemoteAdapter = RemoteAdapter<MasailSubcategory>
    with
        JSONAPIAdapter<MasailSubcategory>,
        ApplicationAdapter<MasailSubcategory>;

final internalMasailSubcategoriesRemoteAdapterProvider =
    Provider<RemoteAdapter<MasailSubcategory>>((ref) =>
        $MasailSubcategoryRemoteAdapter($MasailSubcategoryHiveLocalAdapter(ref),
            InternalHolder(_masailSubcategoriesFinders)));

final masailSubcategoriesRepositoryProvider =
    Provider<Repository<MasailSubcategory>>(
        (ref) => Repository<MasailSubcategory>(ref));

extension MasailSubcategoryDataRepositoryX on Repository<MasailSubcategory> {
  JSONAPIAdapter<MasailSubcategory> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<MasailSubcategory>;
  ApplicationAdapter<MasailSubcategory> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<MasailSubcategory>;
}

extension MasailSubcategoryRelationshipGraphNodeX
    on RelationshipGraphNode<MasailSubcategory> {
  RelationshipGraphNode<MasailCategory> get masailCategory {
    final meta = $MasailSubcategoryLocalAdapter
            ._kMasailSubcategoryRelationshipMetas['masail-category']
        as RelationshipMeta<MasailCategory>;
    return meta.clone(
        parent: this is RelationshipMeta ? this as RelationshipMeta : null);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MasailSubcategory _$MasailSubcategoryFromJson(Map<String, dynamic> json) =>
    MasailSubcategory(
      id: json['id'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String,
      position: json['position'] as int?,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
      masailCategory: json['masail-category'] == null
          ? null
          : BelongsTo<MasailCategory>.fromJson(
              json['masail-category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MasailSubcategoryToJson(MasailSubcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'position': instance.position,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
      'masail-category': instance.masailCategory,
    };

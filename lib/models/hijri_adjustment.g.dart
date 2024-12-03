// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hijri_adjustment.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $HijriAdjustmentLocalAdapter on LocalAdapter<HijriAdjustment> {
  static final Map<String, RelationshipMeta>
      _kHijriAdjustmentRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kHijriAdjustmentRelationshipMetas;

  @override
  HijriAdjustment deserialize(map) {
    map = transformDeserialize(map);
    return _$HijriAdjustmentFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$HijriAdjustmentToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _hijriAdjustmentsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $HijriAdjustmentHiveLocalAdapter = HiveLocalAdapter<HijriAdjustment>
    with $HijriAdjustmentLocalAdapter;

class $HijriAdjustmentRemoteAdapter = RemoteAdapter<HijriAdjustment>
    with JSONAPIAdapter<HijriAdjustment>, ApplicationAdapter<HijriAdjustment>;

final internalHijriAdjustmentsRemoteAdapterProvider =
    Provider<RemoteAdapter<HijriAdjustment>>((ref) =>
        $HijriAdjustmentRemoteAdapter($HijriAdjustmentHiveLocalAdapter(ref),
            InternalHolder(_hijriAdjustmentsFinders)));

final hijriAdjustmentsRepositoryProvider =
    Provider<Repository<HijriAdjustment>>(
        (ref) => Repository<HijriAdjustment>(ref));

extension HijriAdjustmentDataRepositoryX on Repository<HijriAdjustment> {
  JSONAPIAdapter<HijriAdjustment> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<HijriAdjustment>;
  ApplicationAdapter<HijriAdjustment> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<HijriAdjustment>;
}

extension HijriAdjustmentRelationshipGraphNodeX
    on RelationshipGraphNode<HijriAdjustment> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HijriAdjustment _$HijriAdjustmentFromJson(Map<String, dynamic> json) =>
    HijriAdjustment(
      id: json['id'] as String?,
      country: json['country'] as String,
      countryCode: json['country-code'] as String,
      adjustment: (json['adjustment'] as num).toInt(),
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$HijriAdjustmentToJson(HijriAdjustment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'country-code': instance.countryCode,
      'adjustment': instance.adjustment,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

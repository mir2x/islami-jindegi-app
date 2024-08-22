// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $CityLocalAdapter on LocalAdapter<City> {
  static final Map<String, RelationshipMeta> _kCityRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kCityRelationshipMetas;

  @override
  City deserialize(map) {
    map = transformDeserialize(map);
    return _$CityFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$CityToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _citiesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $CityHiveLocalAdapter = HiveLocalAdapter<City> with $CityLocalAdapter;

class $CityRemoteAdapter = RemoteAdapter<City>
    with JSONAPIAdapter<City>, LocalLocationAdapter<City>;

final internalCitiesRemoteAdapterProvider = Provider<RemoteAdapter<City>>(
    (ref) => $CityRemoteAdapter(
        $CityHiveLocalAdapter(ref), InternalHolder(_citiesFinders)));

final citiesRepositoryProvider =
    Provider<Repository<City>>((ref) => Repository<City>(ref));

extension CityDataRepositoryX on Repository<City> {
  JSONAPIAdapter<City> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<City>;
  LocalLocationAdapter<City> get localLocationAdapter =>
      remoteAdapter as LocalLocationAdapter<City>;
}

extension CityRelationshipGraphNodeX on RelationshipGraphNode<City> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      id: json['id'] as String,
      name: json['name'] as String,
      nameBn: json['name-bn'] as String?,
      countryCode: json['country-code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] as String,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name-bn': instance.nameBn,
      'country-code': instance.countryCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'timezone': instance.timezone,
    };

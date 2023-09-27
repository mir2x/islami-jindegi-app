// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $CountryLocalAdapter on LocalAdapter<Country> {
  static final Map<String, RelationshipMeta> _kCountryRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kCountryRelationshipMetas;

  @override
  Country deserialize(map) {
    map = transformDeserialize(map);
    return _$CountryFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$CountryToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _countriesFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $CountryHiveLocalAdapter = HiveLocalAdapter<Country>
    with $CountryLocalAdapter;

class $CountryRemoteAdapter = RemoteAdapter<Country>
    with JSONAPIAdapter<Country>, LocalLocationAdapter<Country>;

final internalCountriesRemoteAdapterProvider = Provider<RemoteAdapter<Country>>(
    (ref) => $CountryRemoteAdapter(
        $CountryHiveLocalAdapter(ref), InternalHolder(_countriesFinders)));

final countriesRepositoryProvider =
    Provider<Repository<Country>>((ref) => Repository<Country>(ref));

extension CountryDataRepositoryX on Repository<Country> {
  JSONAPIAdapter<Country> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Country>;
  LocalLocationAdapter<Country> get localLocationAdapter =>
      remoteAdapter as LocalLocationAdapter<Country>;
}

extension CountryRelationshipGraphNodeX on RelationshipGraphNode<Country> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: json['id'] as String,
      name: json['name'] as String,
      nameBn: json['name-bn'] as String?,
      code: json['code'] as String,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name-bn': instance.nameBn,
      'code': instance.code,
    };

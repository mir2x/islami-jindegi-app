// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $SettingLocalAdapter on LocalAdapter<Setting> {
  static final Map<String, RelationshipMeta> _kSettingRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kSettingRelationshipMetas;

  @override
  Setting deserialize(map) {
    map = transformDeserialize(map);
    return _$SettingFromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = _$SettingToJson(model);
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _settingsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $SettingHiveLocalAdapter = HiveLocalAdapter<Setting>
    with $SettingLocalAdapter;

class $SettingRemoteAdapter = RemoteAdapter<Setting>
    with JSONAPIAdapter<Setting>, ApplicationAdapter<Setting>;

final internalSettingsRemoteAdapterProvider = Provider<RemoteAdapter<Setting>>(
    (ref) => $SettingRemoteAdapter(
        $SettingHiveLocalAdapter(ref), InternalHolder(_settingsFinders)));

final settingsRepositoryProvider =
    Provider<Repository<Setting>>((ref) => Repository<Setting>(ref));

extension SettingDataRepositoryX on Repository<Setting> {
  JSONAPIAdapter<Setting> get jSONAPIAdapter =>
      remoteAdapter as JSONAPIAdapter<Setting>;
  ApplicationAdapter<Setting> get applicationAdapter =>
      remoteAdapter as ApplicationAdapter<Setting>;
}

extension SettingRelationshipGraphNodeX on RelationshipGraphNode<Setting> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      id: json['id'] as String?,
      askQuestion: json['ask-question'] as bool,
      displayOfflineQuran: json['display-offline-quran'] as bool,
      createdAt: json['created-at'] as String?,
      updatedAt: json['updated-at'] as String?,
    );

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'id': instance.id,
      'ask-question': instance.askQuestion,
      'display-offline-quran': instance.displayOfflineQuran,
      'created-at': instance.createdAt,
      'updated-at': instance.updatedAt,
    };

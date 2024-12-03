// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_location_api.dart';

// ignore_for_file: type=lint
class $CountriesTable extends Countries
    with TableInfo<$CountriesTable, Country> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CountriesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> nameBn = GeneratedColumn<String>(
      'name_bn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, nameBn, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'countries';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Country map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Country(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameBn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_bn']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
    );
  }

  @override
  $CountriesTable createAlias(String alias) {
    return $CountriesTable(attachedDatabase, alias);
  }
}

class Country extends DataClass implements Insertable<Country> {
  final String id;
  final String name;
  final String? nameBn;
  final String code;
  const Country(
      {required this.id, required this.name, this.nameBn, required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameBn != null) {
      map['name_bn'] = Variable<String>(nameBn);
    }
    map['code'] = Variable<String>(code);
    return map;
  }

  factory Country.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Country(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameBn: serializer.fromJson<String?>(json['nameBn']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameBn': serializer.toJson<String?>(nameBn),
      'code': serializer.toJson<String>(code),
    };
  }

  Country copyWith(
          {String? id,
          String? name,
          Value<String?> nameBn = const Value.absent(),
          String? code}) =>
      Country(
        id: id ?? this.id,
        name: name ?? this.name,
        nameBn: nameBn.present ? nameBn.value : this.nameBn,
        code: code ?? this.code,
      );
  Country copyWithCompanion(CountriesCompanion data) {
    return Country(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameBn: data.nameBn.present ? data.nameBn.value : this.nameBn,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Country(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nameBn, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Country &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameBn == this.nameBn &&
          other.code == this.code);
}

class CountriesCompanion extends UpdateCompanion<Country> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameBn;
  final Value<String> code;
  final Value<int> rowid;
  const CountriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameBn = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CountriesCompanion.insert({
    required String id,
    required String name,
    this.nameBn = const Value.absent(),
    required String code,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        code = Value(code);
  static Insertable<Country> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameBn,
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameBn != null) 'name_bn': nameBn,
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CountriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? nameBn,
      Value<String>? code,
      Value<int>? rowid}) {
    return CountriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameBn.present) {
      map['name_bn'] = Variable<String>(nameBn.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitiesTable extends Cities with TableInfo<$CitiesTable, City> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitiesTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> nameBn = GeneratedColumn<String>(
      'name_bn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
      'country_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
      'timezone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, nameBn, countryCode, latitude, longitude, timezone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cities';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  City map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return City(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameBn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_bn']),
      countryCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country_code'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      timezone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timezone']),
    );
  }

  @override
  $CitiesTable createAlias(String alias) {
    return $CitiesTable(attachedDatabase, alias);
  }
}

class City extends DataClass implements Insertable<City> {
  final String id;
  final String name;
  final String? nameBn;
  final String countryCode;
  final double latitude;
  final double longitude;
  final String? timezone;
  const City(
      {required this.id,
      required this.name,
      this.nameBn,
      required this.countryCode,
      required this.latitude,
      required this.longitude,
      this.timezone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameBn != null) {
      map['name_bn'] = Variable<String>(nameBn);
    }
    map['country_code'] = Variable<String>(countryCode);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || timezone != null) {
      map['timezone'] = Variable<String>(timezone);
    }
    return map;
  }

  factory City.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return City(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameBn: serializer.fromJson<String?>(json['nameBn']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      timezone: serializer.fromJson<String?>(json['timezone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'nameBn': serializer.toJson<String?>(nameBn),
      'countryCode': serializer.toJson<String>(countryCode),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'timezone': serializer.toJson<String?>(timezone),
    };
  }

  City copyWith(
          {String? id,
          String? name,
          Value<String?> nameBn = const Value.absent(),
          String? countryCode,
          double? latitude,
          double? longitude,
          Value<String?> timezone = const Value.absent()}) =>
      City(
        id: id ?? this.id,
        name: name ?? this.name,
        nameBn: nameBn.present ? nameBn.value : this.nameBn,
        countryCode: countryCode ?? this.countryCode,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        timezone: timezone.present ? timezone.value : this.timezone,
      );
  City copyWithCompanion(CitiesCompanion data) {
    return City(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameBn: data.nameBn.present ? data.nameBn.value : this.nameBn,
      countryCode:
          data.countryCode.present ? data.countryCode.value : this.countryCode,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('City(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('countryCode: $countryCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timezone: $timezone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, nameBn, countryCode, latitude, longitude, timezone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is City &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameBn == this.nameBn &&
          other.countryCode == this.countryCode &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.timezone == this.timezone);
}

class CitiesCompanion extends UpdateCompanion<City> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> nameBn;
  final Value<String> countryCode;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> timezone;
  final Value<int> rowid;
  const CitiesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameBn = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.timezone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitiesCompanion.insert({
    required String id,
    required String name,
    this.nameBn = const Value.absent(),
    required String countryCode,
    required double latitude,
    required double longitude,
    this.timezone = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        countryCode = Value(countryCode),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<City> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? nameBn,
    Expression<String>? countryCode,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? timezone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameBn != null) 'name_bn': nameBn,
      if (countryCode != null) 'country_code': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (timezone != null) 'timezone': timezone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? nameBn,
      Value<String>? countryCode,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String?>? timezone,
      Value<int>? rowid}) {
    return CitiesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameBn.present) {
      map['name_bn'] = Variable<String>(nameBn.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitiesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameBn: $nameBn, ')
          ..write('countryCode: $countryCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timezone: $timezone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalLocationAPI extends GeneratedDatabase {
  _$LocalLocationAPI(QueryExecutor e) : super(e);
  $LocalLocationAPIManager get managers => $LocalLocationAPIManager(this);
  late final $CountriesTable countries = $CountriesTable(this);
  late final $CitiesTable cities = $CitiesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [countries, cities];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CountriesTableCreateCompanionBuilder = CountriesCompanion Function({
  required String id,
  required String name,
  Value<String?> nameBn,
  required String code,
  Value<int> rowid,
});
typedef $$CountriesTableUpdateCompanionBuilder = CountriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> nameBn,
  Value<String> code,
  Value<int> rowid,
});

class $$CountriesTableTableManager extends RootTableManager<
    _$LocalLocationAPI,
    $CountriesTable,
    Country,
    $$CountriesTableFilterComposer,
    $$CountriesTableOrderingComposer,
    $$CountriesTableCreateCompanionBuilder,
    $$CountriesTableUpdateCompanionBuilder> {
  $$CountriesTableTableManager(_$LocalLocationAPI db, $CountriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CountriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CountriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameBn = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CountriesCompanion(
            id: id,
            name: name,
            nameBn: nameBn,
            code: code,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> nameBn = const Value.absent(),
            required String code,
            Value<int> rowid = const Value.absent(),
          }) =>
              CountriesCompanion.insert(
            id: id,
            name: name,
            nameBn: nameBn,
            code: code,
            rowid: rowid,
          ),
        ));
}

class $$CountriesTableFilterComposer
    extends FilterComposer<_$LocalLocationAPI, $CountriesTable> {
  $$CountriesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nameBn => $state.composableBuilder(
      column: $state.table.nameBn,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CountriesTableOrderingComposer
    extends OrderingComposer<_$LocalLocationAPI, $CountriesTable> {
  $$CountriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nameBn => $state.composableBuilder(
      column: $state.table.nameBn,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CitiesTableCreateCompanionBuilder = CitiesCompanion Function({
  required String id,
  required String name,
  Value<String?> nameBn,
  required String countryCode,
  required double latitude,
  required double longitude,
  Value<String?> timezone,
  Value<int> rowid,
});
typedef $$CitiesTableUpdateCompanionBuilder = CitiesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> nameBn,
  Value<String> countryCode,
  Value<double> latitude,
  Value<double> longitude,
  Value<String?> timezone,
  Value<int> rowid,
});

class $$CitiesTableTableManager extends RootTableManager<
    _$LocalLocationAPI,
    $CitiesTable,
    City,
    $$CitiesTableFilterComposer,
    $$CitiesTableOrderingComposer,
    $$CitiesTableCreateCompanionBuilder,
    $$CitiesTableUpdateCompanionBuilder> {
  $$CitiesTableTableManager(_$LocalLocationAPI db, $CitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CitiesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CitiesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> nameBn = const Value.absent(),
            Value<String> countryCode = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String?> timezone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CitiesCompanion(
            id: id,
            name: name,
            nameBn: nameBn,
            countryCode: countryCode,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> nameBn = const Value.absent(),
            required String countryCode,
            required double latitude,
            required double longitude,
            Value<String?> timezone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CitiesCompanion.insert(
            id: id,
            name: name,
            nameBn: nameBn,
            countryCode: countryCode,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone,
            rowid: rowid,
          ),
        ));
}

class $$CitiesTableFilterComposer
    extends FilterComposer<_$LocalLocationAPI, $CitiesTable> {
  $$CitiesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nameBn => $state.composableBuilder(
      column: $state.table.nameBn,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get countryCode => $state.composableBuilder(
      column: $state.table.countryCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get timezone => $state.composableBuilder(
      column: $state.table.timezone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CitiesTableOrderingComposer
    extends OrderingComposer<_$LocalLocationAPI, $CitiesTable> {
  $$CitiesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nameBn => $state.composableBuilder(
      column: $state.table.nameBn,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get countryCode => $state.composableBuilder(
      column: $state.table.countryCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get latitude => $state.composableBuilder(
      column: $state.table.latitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get longitude => $state.composableBuilder(
      column: $state.table.longitude,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get timezone => $state.composableBuilder(
      column: $state.table.timezone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $LocalLocationAPIManager {
  final _$LocalLocationAPI _db;
  $LocalLocationAPIManager(this._db);
  $$CountriesTableTableManager get countries =>
      $$CountriesTableTableManager(_db, _db.countries);
  $$CitiesTableTableManager get cities =>
      $$CitiesTableTableManager(_db, _db.cities);
}

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'tables/index.dart';

part 'local_location_api.g.dart';

@DriftDatabase(
  tables: [
    Countries,
    Cities,
  ],
)
class LocalLocationAPI extends _$LocalLocationAPI {
  LocalLocationAPI()
      : super(
          LazyDatabase(() async {
            int dataVersion = 1;

            final dbFolder = await getApplicationDocumentsDirectory();
            final file = File(
              p.join(dbFolder.path, 'offline_location_$dataVersion.sqlite3'),
            );

            if (!await file.exists()) {
              // delete previous file
              final previousFiles = Glob(
                p.join(dbFolder.path, 'offline_location_*.sqlite3'),
              );
              for (var previousFile in previousFiles.listSync()) {
                await previousFile.delete();
              }

              // load current file
              final blob = await rootBundle
                  .load('assets/db/offline_location_$dataVersion.sqlite3');
              await file.writeAsBytes(
                blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
              );
            }

            return NativeDatabase(file);
          }),
        );

  // bump this number whenever a table definition has been added or changed.
  @override
  int get schemaVersion => 1;

  Future<List> query(String tableName, {params = const {}}) async {
    switch (tableName) {
      case 'countries':
        return queryCountry(params);
      case 'cities':
        return queryCity(params);
      default:
        return [];
    }
  }

  Future? findById(String tableName, String id, {params = const {}}) async {
    switch (tableName) {
      case 'countries':
        return findCountryById(id);
      case 'cities':
        return findCityById(id);
      default:
        return null;
    }
  }

  Future<List<Country>> queryCountry(Map params) {
    var query = select(countries);

    if (params.containsKey('code')) {
      query.where((t) => t.code.equals(params['code'].toString()));
    }

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    return query.get();
  }

  Future<Country?> findCountryById(String id) {
    return (select(countries)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<City>> queryCity(Map params) {
    var query = select(cities);

    if (params.containsKey('country_code')) {
      query.where(
        (t) => t.countryCode.equals(params['country_code'].toString()),
      );
    }

    if (params.containsKey('page') && params.containsKey('per_page')) {
      query.limit(
        params['per_page'],
        offset: (params['page'] - 1) * params['per_page'],
      );
    } else {
      query.limit(params['quantity'] ?? 20);
    }

    return query.get();
  }

  Future<City?> findCityById(String id) {
    return (select(cities)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}

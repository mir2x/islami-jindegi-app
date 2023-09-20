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

  Future<List<Country>> queryCountry(Map params) {
    var query = select(countries);
    query.orderBy([(t) => OrderingTerm(expression: t.name)]);

    return query.get();
  }

  Future<List<City>> queryCity(Map params) {
    var query = select(cities);

    query.where(
      (t) => t.countryCode.equals(params['country_code'].toString()),
    );

    query.orderBy([(t) => OrderingTerm(expression: t.name)]);

    return query.get();
  }
}

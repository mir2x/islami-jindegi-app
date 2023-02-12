import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'tables/index.dart';

part 'local_database.g.dart';

@DriftDatabase(tables: [Masails])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(
    LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'init.sqlite3'));

      if (!await file.exists()) {
          // Extract the pre-populated database file from assets
          final blob = await rootBundle.load('assets/db/init.sqlite3');
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
}

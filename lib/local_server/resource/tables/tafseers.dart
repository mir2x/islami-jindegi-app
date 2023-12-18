import 'package:drift/drift.dart';
import 'tafseer_qitabs.dart';
import 'ayahs.dart';

class Tafseers extends Table {
  TextColumn get id => text()();
  TextColumn get body => text()();

  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get tafseerQitabId => text().references(TafseerQitabs, #id)();
  TextColumn get ayahId => text().references(Ayahs, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

import 'package:drift/drift.dart';
import 'ayahs.dart';

class AyahTranslations extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  TextColumn get ayahId => text().references(Ayahs, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

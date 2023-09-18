import 'dart:convert';
import 'package:drift/drift.dart';

class FileData extends TypeConverter<Map, String> {
  const FileData();

  @override
  Map fromSql(String fromDb) {
    return json.decode(fromDb) as Map;
  }

  @override
  String toSql(Map value) {
    return json.encode(value);
  }
}

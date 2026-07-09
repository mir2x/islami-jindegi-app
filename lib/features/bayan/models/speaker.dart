/// Pure Dart model for Speaker — no Flutter Data dependency.
///
/// Bayan has no dedicated "speaker" entity on the .NET API — it was unified
/// into the shared `Authors` table during the Rails -> .NET migration (see
/// `MigrateDataCommand.MigrateModuleAuthors(old, db, "speakers", ...)`), and
/// is exposed as `author`/`authorId` in the bayan endpoints, matching every
/// other content module. This model keeps the bayan-domain-appropriate
/// "Speaker" name at the Flutter layer while parsing that same flat
/// AuthorResponse/BayanAuthorOption JSON shape.
class Speaker {
  final String id;
  final String name;
  final String? info;
  final int? position;

  Speaker({
    required this.id,
    required this.name,
    this.info,
    this.position,
  });

  /// From the .NET API's flat AuthorResponse/BayanAuthorOption JSON
  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      info: json['info'],
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory Speaker.fromDb(Map<String, dynamic> row) {
    return Speaker(
      id: row['id'].toString(),
      name: row['name'] ?? '',
      info: row['info'],
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

/// Pure Dart model for MasailAuthor.
class MasailAuthor {
  final String id;
  final String name;
  final String? info;
  final int? position;

  MasailAuthor({
    required this.id,
    required this.name,
    this.info,
    this.position,
  });

  /// From the .NET API's flat AuthorResponse/MasailAuthorOption JSON
  factory MasailAuthor.fromJson(Map<String, dynamic> json) {
    return MasailAuthor(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      info: json['info'],
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory MasailAuthor.fromDb(Map<String, dynamic> row) {
    return MasailAuthor(
      id: row['id'].toString(),
      name: row['name'] ?? '',
      info: row['info'],
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

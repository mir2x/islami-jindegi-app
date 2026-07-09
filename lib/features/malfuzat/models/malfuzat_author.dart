/// Pure Dart model for MalfuzatAuthor.
class MalfuzatAuthor {
  final String id;
  final String name;
  final String? info;
  final int? position;

  MalfuzatAuthor({
    required this.id,
    required this.name,
    this.info,
    this.position,
  });

  /// From the .NET API's flat AuthorResponse/MalfuzatAuthorOption JSON
  factory MalfuzatAuthor.fromJson(Map<String, dynamic> json) {
    return MalfuzatAuthor(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      info: json['info'],
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory MalfuzatAuthor.fromDb(Map<String, dynamic> row) {
    return MalfuzatAuthor(
      id: row['id'].toString(),
      name: row['name'] ?? '',
      info: row['info'],
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

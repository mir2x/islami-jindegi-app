class BookAuthor {
  final String id;
  final String name;
  final String? info;
  final int? position;

  BookAuthor({
    required this.id,
    required this.name,
    this.info,
    this.position,
  });

  /// From JSON:API `included` resource attributes
  factory BookAuthor.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return BookAuthor(
      id: resource['id'].toString(),
      name: attrs['name'] ?? '',
      info: attrs['info'],
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }

  /// From local SQLite row
  factory BookAuthor.fromDb(Map<String, dynamic> row) {
    return BookAuthor(
      id: row['id'].toString(),
      name: row['name'] ?? '',
      info: row['info'],
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

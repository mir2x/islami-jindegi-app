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

  /// From the .NET API's flat AuthorResponse/BookAuthorOption JSON
  factory BookAuthor.fromJson(Map<String, dynamic> json) {
    return BookAuthor(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      info: json['info'],
      position: json['position'] is int ? json['position'] : null,
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

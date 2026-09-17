class BookCategory {
  final String id;
  final String title;
  final int? position;

  BookCategory({
    required this.id,
    required this.title,
    this.position,
  });

  /// From the .NET API's flat CategoryResponse/BookCategoryOption JSON
  factory BookCategory.fromJson(Map<String, dynamic> json) {
    return BookCategory(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      position: json['position'] is int ? json['position'] : null,
    );
  }

  /// From local SQLite row
  factory BookCategory.fromDb(Map<String, dynamic> row) {
    return BookCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

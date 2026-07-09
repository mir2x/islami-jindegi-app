/// Pure Dart model for MasailCategory.
///
/// Flat — the .NET API's `GetCategoriesAsync` only returns top-level
/// categories (`ParentId == null`) with `Count > 0`, matching how the web app
/// and the book module's category filter work. No subcategory drill-down.
class MasailCategory {
  final String id;
  final String title;
  final int? position;

  MasailCategory({
    required this.id,
    required this.title,
    this.position,
  });

  /// From the .NET API's flat CategoryResponse/MasailCategoryOption JSON
  factory MasailCategory.fromJson(Map<String, dynamic> json) {
    return MasailCategory(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory MasailCategory.fromDb(Map<String, dynamic> row) {
    return MasailCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

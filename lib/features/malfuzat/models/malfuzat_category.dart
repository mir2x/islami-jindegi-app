/// Pure Dart model for MalfuzatCategory.
/// Category filtering is flat (top-level only) — matches the .NET API's
/// `GetCategoriesAsync`, which only returns top-level categories with
/// `Count > 0`. No subcategory drill-down (see `malfuzat_subcategory.dart`
/// removal in the .NET migration).
class MalfuzatCategory {
  final String id;
  final String title;
  final int? position;

  MalfuzatCategory({
    required this.id,
    required this.title,
    this.position,
  });

  /// From the .NET API's flat CategoryResponse/MalfuzatCategoryOption JSON
  factory MalfuzatCategory.fromJson(Map<String, dynamic> json) {
    return MalfuzatCategory(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory MalfuzatCategory.fromDb(Map<String, dynamic> row) {
    return MalfuzatCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

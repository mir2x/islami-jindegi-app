/// Pure Dart model for BayanCategory.
/// Category filtering is flat (top-level only) — matches the .NET API's
/// `GetCategoriesAsync`, which only returns top-level categories with
/// `Count > 0`. No subcategory drill-down.
class BayanCategory {
  final String id;
  final String title;
  final int? position;

  BayanCategory({
    required this.id,
    required this.title,
    this.position,
  });

  /// From the .NET API's flat CategoryResponse/BayanCategoryOption JSON
  factory BayanCategory.fromJson(Map<String, dynamic> json) {
    return BayanCategory(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory BayanCategory.fromDb(Map<String, dynamic> row) {
    return BayanCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

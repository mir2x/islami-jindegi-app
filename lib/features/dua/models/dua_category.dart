/// Pure Dart model for DuaCategory.
///
/// Flat — the .NET API's `GetCategoriesAsync` only returns top-level
/// categories (`ParentId == null`) with `Count > 0`, matching how the web app
/// and every other module's category filter work. No subcategory drill-down.
class DuaCategory {
  final String id;
  final String title;
  final int? position;

  DuaCategory({
    required this.id,
    required this.title,
    this.position,
  });

  /// From the .NET API's flat CategoryResponse/DuaCategoryOption JSON.
  factory DuaCategory.fromJson(Map<String, dynamic> json) {
    return DuaCategory(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      position: json['position'] is int ? json['position'] : null,
    );
  }

  factory DuaCategory.fromDb(Map<String, dynamic> row) {
    return DuaCategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}

/// Pure Dart model for MalfuzatSubcategory.
class MalfuzatSubcategory {
  final String id;
  final String title;
  final int? position;

  MalfuzatSubcategory({
    required this.id,
    required this.title,
    this.position,
  });

  factory MalfuzatSubcategory.fromJsonApi(Map<String, dynamic> resource) {
    final attrs = resource['attributes'] as Map<String, dynamic>? ?? {};
    return MalfuzatSubcategory(
      id: resource['id']?.toString() ?? '',
      title: attrs['title'] ?? '',
      position: attrs['position'] is int ? attrs['position'] : null,
    );
  }

  factory MalfuzatSubcategory.fromDb(Map<String, dynamic> row) {
    return MalfuzatSubcategory(
      id: row['id'].toString(),
      title: row['title'] ?? '',
      position: row['position'] is int ? row['position'] : null,
    );
  }
}
